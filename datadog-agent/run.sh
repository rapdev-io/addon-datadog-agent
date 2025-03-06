#!/usr/bin/with-contenv bashio

export DD_API_KEY=$(bashio::config 'api_key')
export DD_SITE=$(bashio::config 'site')

# Execute the original Datadog Agent entrypoint
exec /entrypoint.sh

