# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile

ARG BUILD_FROM
FROM datadog/agent:latest

ARG BASHIO_VERSION="v0.16.3"

RUN apt-get update \
 && apt-get install --no-install-recommends -y less vim jq

RUN curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
        /tmp/bashio.tar.gz \
        --strip 1 -C /tmp/bashio \
    \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio 

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
