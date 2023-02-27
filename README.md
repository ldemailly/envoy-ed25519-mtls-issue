# envoy-ed25519-mtls-issue

## Description
The purpose of this repo is to demonstrate the following issue with envoy.

envoy currently supports using ed25519 cert chains for TLS server certs.
We have tested that and it works fine using TLS 1.3.
However, envoy is currently unable to accept mutual-auth (mTLS) connections
using TLS 1.3 when the client certificate is using ed25519 as the cert signing 
algorithm.

This repo contains scripts to reproduce the issue by doing the following.
* Generate all of the client and server certs needed to perform the test.
* Create a custom envoy docker image that includes the TLS 1.3 test config and certs.
* Run the above-created custom docker image.
* Run 5 test TLS 1.3 HTTPS connections to demonstrate the following:
  * Pure RSA environment.  RSA client cert connects to Endpoint using RSA server cert with TLS 1.3.
    * This test is **successful** in the current version of envoy.
  * RSA client cert with ED25519 server cert with TLS 1.3.
    * This test is **successful** in the current version of envoy.
  * ED25519 client cert with RSA server cert with TLS 1.3.
    * This test is **NOT successful** in the current version of envoy.
    * The error message from the openssl client is: `curl: (56) OpenSSL SSL_read: OpenSSL/1.1.1s: error:1409445C:SSL routines:ssl3_read_bytes:tlsv13 alert certificate required, errno 0`
  * Pure ED25519 environment.  ED25519 client cert with ED25519 server cert with TLS 1.3
    * This test is **NOT successful** in the current version of envoy.
    * The error message from the openssl client is: `curl: (56) OpenSSL SSL_read: OpenSSL/1.1.1s: error:1409445C:SSL routines:ssl3_read_bytes:tlsv13 alert certificate required, errno 0`
  * Same exact curl command as the previous one, but against a fortio golang tls server
    * This test is **succesful** showing the certs, curl invocation, etc aren't the issue and it's unique to current envoy

## Installation
(Mac)
* Install a recent curl - A fairly recent version of curl is needed in order to support ED25519 certs and TLS 1.3.
  * `brew install curl`
* Install openssl - preferably v3.x - A fairly recent version of OpenSSL is needed to support ED25519 certs and TLS 1.3.
  * `brew install openssl@3`

Don't forget to do the PATH changes needed to pick up curl and openssl from the newly install brew location.

## Usage
* Generate all certs required for this demo.
  * `./create-certs.sh`
* Build envoy docker image with above certs and required envoy config.
  * `./build.sh`
* Run docker image
  * `./docker-run.sh`
* Run test connections (in separate terminal window)
  * `./docker-test.sh`

After running the above script (docker-test.sh), you will see verbose logs 
for the 4 test connections that demonstrate the 2 success test cases
and 2 failure test cases described above under "Description".

## Analysis
RFC 8446, section 4.2.3, lists the signature algorithms that may be used in digital signature algorithms in TLS 1.3.
During the mTLS handshake the server sends the client the list of supported algorithms that the client may use
for signing.  Envoy appears to not include the signature algorithm `ed25519(0x0807)` in the list of algorithms sent
from the server to the client.  As a result, a suitable client certificate is not found and the "certificate required" error occurs.

For example, with the above test environment, run the following:
* `openssl s_client -connect localhost:10000 --cert certs/client-ed25519.crt --key certs/client-ed25519.key -CAfile certs/ca-ed25519.crt`

The above openssl command fails with the 'certificate required' error, and also returns
```
Requested Signature Algorithms: ECDSA+SHA256:RSA-PSS+SHA256:RSA+SHA256:ECDSA+SHA384:RSA-PSS+SHA384:RSA+SHA384:RSA-PSS+SHA512:RSA+SHA512:RSA+SHA1
Shared Requested Signature Algorithms: ECDSA+SHA256:RSA-PSS+SHA256:RSA+SHA256:ECDSA+SHA384:RSA-PSS+SHA384:RSA+SHA384:RSA-PSS+SHA512:RSA+SHA512
```

Looking at the BoringSSL source code, the full list of signature algorithms seems to be defined here:
https://github.com/google/boringssl/blob/59b53a5594b28127581449c2f7bb6b031fb2333a/include/openssl/ssl.h#L1060-L1071


## Status
This following issue has been filed to the envoy team:
https://github.com/envoyproxy/envoy/issues/25727

