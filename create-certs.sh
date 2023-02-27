pushd certs
./clean.sh
./create-ca.sh
./create-server.sh
./create-client.sh
./create-ca-ed25519.sh
./create-server-ed25519.sh
./create-client-ed25519.sh
popd
