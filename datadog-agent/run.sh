#!/usr/bin/with-contenv bashio

#export DD_API_KEY=$(bashio::config 'api_key')
#export DD_SITE=$(bashio::config 'site')
#HOSTNAME=$(bashio::config 'hostname')
#export DD_DOGSTATSD_NON_LOCAL_TRAFFIC= "true"

# Execute the original Datadog Agent entrypoint
DD_API_KEY="$(bashio::config 'api_key')" \
DD_SITE="$(bashio::config 'site')" \
DD_HOSTNAME="$(bashio::config 'hostname')" \
DD_DOGSTATSD_NON_LOCAL_TRAFFIC="true" \
DD_APM_ENABLED="false" \
DOCKER_SOCKET_PATH="/run/docker.sock" \
DOCKER_HOST="unix:///run/docker.sock" \
exec /init
