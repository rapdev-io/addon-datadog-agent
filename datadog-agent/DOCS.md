# Datadog Agent Add-on for Home Assistant

## Overview

The Datadog Agent add-on integrates the official Datadog Agent into your Home Assistant setup to provide comprehensive system monitoring. It collects host metrics such as CPU, memory, disk, and network usage, and can monitor Docker containers (e.g. other addons). In addition, it exposes a DogStatsD endpoint that allows the companion [Datadog integration](https://github.com/rapdev-io/ha-datadog-metrics) to send custom metrics like sensor data to datadog.

This add-on is optimized for Raspberry Pi 4 and supports Raspberry Pi 3B (using an ARM-compatible image) alongside other architectures.

## Quickstart

1. **Add the Repository:**
   - Navigate to Home Assistant Supervisor > Add-on Store > Repositories.
   - Add the URL of your public GitHub repository containing this add-on.

2. **Install the Add-on:**
   - Locate the **Datadog Agent** add-on in the store.
   - Click **Install**.

3. **Configure the Add-on:**
   - Open the add-on configuration panel.
   - Enter your Datadog API key in the provided field.
   - Optionally, adjust the Datadog site (defaults to `datadoghq.com`).

4. **Start the Add-on:**
   - Click **Start**.
   - The agent will launch with full system access to collect host and container metrics.

5. **(Optional) Wire up custom metrics**
   - Configure the [Home Assistant Datadog integration](https://github.com/rapdev-io/ha-datadog-metrics) to write your desired metrics to the agent.

## Detailed Setup and Configuration

### On Elevated Access Levels Required by this Addon

The Datadog Agent needs elevated privileges to collect in-depth system metrics:

- **Full Access:**  
  The add-on is configured with `full_access: true`, which disables AppArmor restrictions. This is necessary for the agent to access various system resources and host data.

- **Host Networking & PID Sharing:**  
  With `host_network: true` and `host_pid: true`, the agent can monitor the host’s network interfaces and processes directly.

- **Docker Socket Mount:**  
  The agent mounts the host’s `/var/run/docker.sock` to collect Docker container metrics.

Because these privileges bypass many of Home Assistant’s standard security restrictions, this add-on receives a **low security rating** as per Home Assistant’s [security guidelines](https://developers.home-assistant.io/docs/add-ons/presentation#security).  
> **Security Notice:**  
> The elevated access levels are required to provide full host and container monitoring. Only install this add-on if you trust the source.

### How It Works

- **System Metrics Collection:**  
  The agent continuously gathers data on CPU, memory, disk, and network performance from the host. This data is then forwarded to Datadog for monitoring and alerting (if desired :grin:).

- **Docker Monitoring:**  
  By mounting the Docker socket, the agent also collects container metrics, allowing you to monitor your Home Assistant container alongside other Docker containers running on your system.

- **DogStatsD Interface:**  
  The add-on exposes a DogStatsD collector on UDP port 8125. This enables Home Assistant’s Datadog integration to send custom metrics directly to the Datadog Agent (which are forwarded to datadog in the cloud).

### Configuration Options

- **API Key:**  
  The Datadog API key must be provided via the add-on’s options. This key authenticates your agent with Datadog.

- **Datadog Site (optional):**  
  Your Datadog site if you’re not using the default `datadoghq.com`.

### Troubleshooting & FAQs

- **Agent Fails to Start:**  
  Verify that you have entered a valid API key in the configuration. Check the add-on logs for error details.

- **Metrics Not Appearing in Datadog:**  
  Ensure that the DogStatsD port (UDP 8125) is correctly exposed and that Home Assistant’s Datadog integration is configured to send metrics to the correct endpoint.

- **Platform Compatibility:**  
  For Raspberry Pi 3B users running a 32-bit OS, you may need to use an ARM-compatible build (e.g., the IoT Agent) since the official Datadog image targets 64-bit ARM.

## Further Reading

- [Home Assistant Add-on Development Guidelines](https://developers.home-assistant.io/docs/add-ons/)
- [Datadog Agent Documentation](https://docs.datadoghq.com/agent/)
- [Home Assistant Datadog Integration](https://www.home-assistant.io/integrations/datadog/)
- [Add-on Security Rating Guidelines](https://developers.home-assistant.io/docs/add-ons/presentation#security)

