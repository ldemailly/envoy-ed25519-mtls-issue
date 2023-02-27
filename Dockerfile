FROM envoyproxy/envoy-dev:latest
COPY envoy.yaml /etc/envoy/envoy1.yaml
RUN sed "s/certs\//\/etc\/envoy\/certs\//g" /etc/envoy/envoy1.yaml > /etc/envoy/envoy.yaml
COPY certs /etc/envoy/certs
RUN chown envoy:envoy -R /etc/envoy/certs
RUN chmod go+r /etc/envoy/envoy.yaml
EXPOSE 10000 10001 10002 10003 8001
