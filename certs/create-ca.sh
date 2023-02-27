# Generate Private Key and CA Certificate using RSA 256 encryption (4096-bit key)
# -subj "/C=DE/ST=NRW/L=Berlin/O=My Inc/OU=DevOps/CN=www.example.com/emailAddress=dev@www.example.com"
openssl req \
  -nodes \
  -x509 \
  -newkey rsa:4096 \
  -sha256 \
  -days 365 \
  -subj '/CN=RSA-CA' \
  -keyout ca.key \
  -out ca.crt 

# show me
openssl x509 \
  --in ca.crt \
  -text \
  --noout


# Generate PKCS#12 (P12) file for cert; combines both key and certificate together
#openssl pkcs12 -export -inkey ca.key -in ca.crt -out cert.pfx



# Generate SHA256 Fingerprint for Certificate and export to a file
#openssl x509 -noout -fingerprint -sha256 -inform pem -in ca.crt >> fingerprint.txt



