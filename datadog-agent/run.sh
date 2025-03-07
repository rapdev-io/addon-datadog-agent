#!/usr/bin/with-contenv bashio

export DD_API_KEY=$(bashio::config 'api_key')
export DD_SITE=$(bashio::config 'site')
export DD_DOGSTATSD_NON_LOCAL_TRAFFIC= "true"
export DD_CONTAINER_RUNTIME="docker"

# workaround for environment variable timing during agent init
cat <<EOF > /etc/datadog-agent/datadog.yaml
hostname: homeassistant

dogstatsd_non_local_traffic: true

apm_config:
  enabled: false
EOF

# Execute the original Datadog Agent entrypoint
exec /init
