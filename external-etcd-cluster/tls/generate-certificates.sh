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
export SAN="IP:127.0.0.1, IP:192.168.10.10"
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

unset SAN

# Create an etcd client certificate
openssl req -config openssl.conf \
  -new -nodes \
  -keyout private/k0s.key \
  -subj "/CN=k0s.k0s.sandbox" \
  -out k0s.csr

# Sign etcd client certificate
openssl ca -batch -config openssl.conf \
  -extensions etcd_client \
  -keyfile private/ca.key \
  -cert certs/ca.crt \
  -out certs/k0s.crt \
  -infiles k0s.csr

# Generate CA key and certificate
#openssl genrsa -out etcd-ca.key 2048
#openssl req -x509 -new -nodes \
#  -key etcd-ca.key \
#  -sha256 -days 1024 \
#  -subj "/O=k0s sandbox/CN=ca.etcd.k0s.sandbox" \
#  -out etcd-ca.pem
#
## Generate an etcd server certificate
#openssl req -new -nodes \
#  -key etcd-ca.key \
#  -keyout etcd.k0s.sandbox.key \
#  -subj "/CN=etcd.k0s.sandbox" \
#  -out etcd.k0s.sandbox.csr
#
## Sign server certificate
#openssl ca \
#  -keyfile etcd-ca.key \
#  -cert etcd-ca.pem \
#  -out etcd.k0s.sandbox.crt \
#  -infiles etcd.k0s.sandbox.csr
#
### Generate client key and certificate signing request
##openssl req -new -key etcd-client.key -subj "/CN=192.168.1.10" -out etcd-client.csr
##
### Generate client certificate based on CA certificate
##openssl x509 -req -in etcd-client.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out etcd-client.pem -days 1024 -sha256
