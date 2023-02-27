# create client private key
openssl genpkey -algorithm ED25519 -out client-ed25519.key

# create client CSR 
openssl req \
  -new \
  -key client-ed25519.key \
  -subj '/CN=ED25519Client' \
  -out client-ed25519.csr

# sign CSR with root CA
openssl x509 \
  -req \
  -in client-ed25519.csr \
  -CA ca-ed25519.crt \
  -CAkey ca-ed25519.key \
  -CAcreateserial \
  -days 365 \
  -out client-ed25519.crt

# check client cert
openssl x509 \
  --in client-ed25519.crt \
  -text \
  --noout
