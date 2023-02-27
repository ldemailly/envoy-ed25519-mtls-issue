echo 'Pure RSA env'
curl -v --cacert certs/ca.crt --cert certs/client-rsa.crt --key certs/client-rsa.key https://localhost:10001/
echo 
echo 
echo 'RSA client cert / ED25519 server cert'
curl -v --cacert certs/ca-ed25519.crt --cert certs/client-rsa.crt --key certs/client-rsa.key https://localhost:10003/
echo
echo
echo 'ED25519 client cert / RSA server cert'
curl -v --cacert certs/ca.crt --cert certs/client-ed25519.crt --key certs/client-ed25519.key https://localhost:10002/
echo
echo
echo 'Pure ED25519 env'
curl -v --cacert certs/ca-ed25519.crt --cert certs/client-ed25519.crt --key certs/client-ed25519.key https://localhost:10000/
echo
echo
echo 'Same certs work against fortio mtls server'
curl -v --cacert certs/ca-ed25519.crt --cert certs/client-ed25519.crt --key certs/client-ed25519.key https://localhost:8080/debug
