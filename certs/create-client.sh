# create client private key
openssl genrsa -out client-rsa.key 4098

# create client CSR 
openssl req \
  -new \
  -key client-rsa.key \
  -subj '/CN=RSAClient' \
  -out client-rsa.csr

# sign CSR with root CA
openssl x509 \
  -req \
  -in client-rsa.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -days 365 \
  -out client-rsa.crt

# check client cert
openssl x509 \
  --in client-rsa.crt \
  -text \
  --noout
