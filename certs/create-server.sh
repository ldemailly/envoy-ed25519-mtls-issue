# create server private key
openssl genrsa -out server.key 4096

# create server CSR 
openssl req \
  -new \
  -key server.key \
  -subj '/CN=localhost' \
  -out server.csr

# sign CSR with root CA
openssl x509 \
  -req \
  -extfile extfile.txt \
  -in server.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -days 365 \
  -out server.crt

# check server cert
openssl x509 \
  --in server.crt \
  -text \
  --noout
