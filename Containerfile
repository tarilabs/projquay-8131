FROM quay.io/prometheus/busybox

RUN mkdir /models && chmod 775 /models
COPY data/ /models/
