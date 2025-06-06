# Datadog Agent Home Assistant add-on repository

This addon stands up the [Datadog agent](https://docs.datadoghq.com/agent/?tab=cloud_and_container) as a docker container in your HA environment.

Good for:

* Monitoring the health and performance of:
  * the host running HAOS
  * your Home Assistant application containers
  * other addons
* Collecting+shipping your custom metrics (e.g. sensor data) to datadog in conjunction with [a compatible datadog integration](https://github.com/rapdev-io/ha-datadog-metrics)
* Using any datadog platform features on top of the above (e.g. monitors and alerts)

<img width="800" alt="Container Monitoring" src="https://github.com/user-attachments/assets/d80330f6-d01f-4a67-8366-4519afc9e1e6" />

Container monitoring!

<img width="800" alt="Host Monitoring" src="https://github.com/user-attachments/assets/170f06c7-7bcb-47cf-a675-3d1b52d6f534" />

Host monitoring!

## One(ish) Click Install

First [![Add this repository to my Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Frapdev-io%2Faddon-datadog-agent)

Then install via the tile in [![The add-on store](https://my.home-assistant.io/badges/supervisor_store.svg)](https://my.home-assistant.io/redirect/supervisor_store/)

Be patient, initial build might take a while.

Remember to update your API key in `Configuration` before starting the agent, and **disabling Protection mode is advised** for better monitoring. See [DOCS](./datadog-agent/DOCS.md) for more details.

## Also consider

If you want to ship custom metrics (e.g. sensor data) to datadog, consider also using the [Datadog Metrics Action](https://github.com/rapdev-io/ha-datadog-metrics).

## Add-ons

This repository contains the following add-ons

### [Datadog Agent Addon](./datadog-agent)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armv7 Architecture][armv7-shield]


[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
