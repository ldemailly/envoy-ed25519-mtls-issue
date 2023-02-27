# create server private key
openssl genpkey -algorithm ED25519 -out server-ed25519.key 

# create server CSR 
openssl req \
  -new \
  -key server-ed25519.key \
  -subj '/CN=localhost' \
  -out server-ed25519.csr

# sign CSR with root CA
openssl x509 \
  -req \
  -extfile extfile.txt \
  -in server-ed25519.csr \
  -CA ca-ed25519.crt \
  -CAkey ca-ed25519.key \
  -CAcreateserial \
  -days 365 \
  -out server-ed25519.crt

# check server cert
openssl x509 \
  --in server-ed25519.crt \
  -text \
  --noout
