# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile

ARG BUILD_FROM
FROM datadog/agent:latest

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
