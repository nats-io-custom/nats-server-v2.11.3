# Must specify a VERSION, such as 'v2.11.3'
ARG NATSSERVERVERSION=DEVICEVERSION_ARG_MISSING

FROM nats:${NATSSERVERVERSION}

LABEL maintainer="info@mapped.com"
LABEL description="Mapped nats-server Wrapper container"

# Copying the mapped.txt placeholder file always succeeds so that   
# the subsequent wildcard copy of the zitadel binary is optional.
COPY build/nats-server /