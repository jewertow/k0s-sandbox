#!/bin/bash

bash cleanup.sh

mkdir private certs newcerts crl
touch index.txt
echo '01' > serial

# Generate CA key and certificate
openssl req -config openssl.conf \
  -new -x509 -nodes -extensions v3_ca \
  -keyout private/ca.key \
  -subj "/O=k0s sandbox/CN=ca.k0s.sandbox" \
  -out certs/ca.crt

# Generate an etcd server certificate
openssl req -config openssl.conf \
  -new -nodes \
  -keyout private/etcd.key \
  -subj "/CN=etcd.k0s.sandbox"\
  -out etcd.csr

# Sign the cert
openssl ca -batch -config openssl.conf \
  -extensions etcd_server \
  -keyfile private/ca.key \
  -cert certs/ca.crt \
  -out certs/etcd.crt \
  -infiles etcd.csr

for i in {1..2}
do

  # Create an etcd client certificate
  openssl req -config openssl.conf \
    -new -nodes \
    -keyout private/k0s-${i}.key \
    -subj "/CN=k0s-${i}.k0s.sandbox" \
    -out k0s-${i}.csr

  # Sign etcd client certificate
  openssl ca -batch -config openssl.conf \
    -extensions etcd_client \
    -keyfile private/ca.key \
    -cert certs/ca.crt \
    -out certs/k0s-${i}.crt \
    -infiles k0s-${i}.csr

done
