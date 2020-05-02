ARG BUILD_FROM
FROM $BUILD_FROM
ENV LANG C.UTF-8
# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
RUN \
    apk add --no-cache \
        alsa-plugins-pulse=1.2.1-r0 \
        alsa-utils=1.2.1-r0 \
        pulseaudio-utils=13.0-r2

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Alsa & PulseAudio Fix" \
    io.hass.description="This add-on eliminates the problem of 'Device or resource busy' on computers with an external ALSA and PULSEAUDIO caused by the docker container 'hassio_audio'" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Anodev <https://github.com/OPHoperHPO>" \
    org.label-schema.description="This add-on eliminates the problem of 'Device or resource busy' on computers with an external ALSA and PULSEAUDIO caused by the docker container 'hassio_audio'" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Alsa & PulseAudio Fix" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/OPHoperHPO/hassio-addons/tree/master/pulseaudio_fix" \
    org.label-schema.usage="https://github.com/OPHoperHPO/hassio-addons/tree/master/pulseaudio_fix" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/OPHoperHPO/hassio-addons/tree/master/pulseaudio_fix" \
    org.label-schema.vendor="Anodev <https://github.com/OPHoperHPO>"

CMD [ "pactl", "load-module", "module-suspend-on-idle" ]