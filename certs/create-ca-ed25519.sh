openssl genpkey -algorithm ED25519 -out ca-ed25519.key

openssl req \
  -nodes \
  -x509 \
  -key ca-ed25519.key \
  -days 365 \
  -subj '/CN=ED25519-CA' \
  -keyout ca-ed25519.key \
  -out ca-ed25519.crt 

# show me
openssl x509 \
  --in ca-ed25519.crt \
  -text \
  --noout


# Generate PKCS#12 (P12) file for cert; combines both key and certificate together
#openssl pkcs12 -export -inkey ca.key -in ca.crt -out cert.pfx



# Generate SHA256 Fingerprint for Certificate and export to a file
#openssl x509 -noout -fingerprint -sha256 -inform pem -in ca.crt >> fingerprint.txt



