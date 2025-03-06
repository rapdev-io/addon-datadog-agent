#!/usr/bin/with-contenv bashio

export DD_API_KEY=$(bashio::config 'api_key')
export DD_SITE=$(bashio::config 'site')
export DD_DOGSTATSD_NON_LOCAL_TRAFFIC= "true"

# workaround for environment variable timing issue during agent startup
echo "hostname: homeassistant" >> /etc/datadog-agent/datadog.yaml

# Execute the original Datadog Agent entrypoint
exec /init

