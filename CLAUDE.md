# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A **Home Assistant add-on repository** (not application code) that packages the official Datadog Agent so it runs as an add-on inside Home Assistant OS. It contains exactly one add-on, in `datadog-agent/`. `repository.yaml` at the root registers this Git repo as an installable HA add-on source.

The add-on's job: run `datadog/agent` on the HA host with enough privilege to monitor the host, Docker containers (other add-ons), and accept custom metrics via DogStatsD. A companion project, [ha-datadog-metrics](https://github.com/rapdev-io/ha-datadog-metrics), feeds custom sensor metrics to the DogStatsD port this add-on exposes.

## Architecture: how config flows at runtime

Understanding this requires reading `config.yaml`, `run.sh`, and `Dockerfile` together:

1. **`datadog-agent/config.yaml`** — the add-on manifest. Its `options`/`schema` block defines the fields a user fills in via the HA UI (`api_key`, `site`, `hostname`). It also grants the elevated privileges and exposes UDP 8125.
2. **`datadog-agent/run.sh`** — the container entrypoint (`CMD` in the Dockerfile). It reads those UI options with `bashio::config '<key>'`, maps them to `DD_*` environment variables, and then `exec /init` — handing off to the **base Datadog image's own s6-overlay entrypoint**. We do not start the agent ourselves; we only set env and delegate.
3. **`datadog-agent/Dockerfile`** — extends `datadog/agent:latest` and installs `bashio` (plus `less`/`vim`/`jq`). bashio is installed manually because the official Datadog image is not a HA base image and doesn't ship it; `run.sh`'s `#!/usr/bin/with-contenv bashio` shebang and `bashio::config` calls depend on it.

So the chain is: **HA UI options (schema in `config.yaml`) → `bashio::config` in `run.sh` → `DD_*` env vars → base image `/init`.**

## Development workflow

There is no local build/lint/test toolchain. The add-on is built and run by the Home Assistant Supervisor, normally inside the HA add-on devcontainer. The Supervisor rebuilds the image automatically when the Dockerfile or config changes.

VS Code tasks in `.vscode/tasks.json` wrap the Supervisor CLI (`ha`):

- **Start Home Assistant** — runs `supervisor_run` to boot HA in the devcontainer (default test task).
- **Rebuild and Start Addon** — `ha addons rebuild local_datadog-agent; ha addons start local_datadog-agent; docker logs --follow addon_local_datadog-agent`. Use this after changing the Dockerfile, `run.sh`, or `config.yaml`.
- **Start Addon** — stop + start without rebuild (`ha addons stop/start local_datadog-agent`), then tail logs. Use for config-only changes.

The locally-loaded slug is `local_datadog-agent` and the container is `addon_local_datadog-agent`.

## Releasing

HA surfaces an update to users based on the manifest version. To ship a change:

1. Bump `version` in `datadog-agent/config.yaml`.
2. Add a matching entry to `datadog-agent/CHANGELOG.md` (HA renders this in the add-on UI).

`datadog-agent/DOCS.md` is the user-facing documentation rendered in the add-on's Documentation tab — keep it in sync with `config.yaml` behavior.

## Gotchas specific to this add-on

- **`BUILD_FROM` is effectively unused.** `build.yaml` passes a `BUILD_FROM` arg and the Dockerfile declares `ARG BUILD_FROM`, but the Dockerfile hardcodes `FROM datadog/agent:latest`. The base is always the official multi-arch Datadog image regardless of the arg — don't assume changing `build.yaml`'s `BUILD_FROM` changes the base.
- **Docker socket lives at the nonstandard `/run/docker.sock`** (not `/var/run/docker.sock`). Both `config.yaml`'s `environment` block and `run.sh` set `DOCKER_HOST`/`DOCKER_SOCKET_PATH` to it. This was a deliberate fix for container monitoring on HAOS — preserve it.
- **APM is disabled** (`DD_APM_ENABLED="false"` in `run.sh`); **DogStatsD non-local traffic is enabled** (`DD_DOGSTATSD_NON_LOCAL_TRAFFIC="true"`) so other containers can reach UDP 8125.
- **Elevated privileges are intentional and required.** `full_access`, `host_network`, `host_pid`, and `docker_api` are all `true` in `config.yaml`; this is what lets the agent see host + container metrics, and it's why the add-on gets a low HA security rating and needs Protection Mode disabled.
