docker run -p 8080:8080 -v `pwd`/certs:/var/lib/fortio/certs fortio/fortio:1.52.0 server -mtls -cert ./certs/server-ed25519.crt -key ./certs/server-ed25519.key -cacert ./certs/ca-ed25519.crt &
docker run -it -p 8001:8001 -p 10000:10000 -p 10001:10001 -p 10002:10002 -p 10003:10003 envoy:v1
