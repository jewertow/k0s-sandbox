# k0s with external etcd cluster and enabled TLS

```bash
vagrant up
vagrant ssh etcd

ETCDCTL_API=3 etcdctl --endpoints=https://192.168.10.10:2379 \
    --cacert="/etc/pki/CA/ca.crt" \
    --cert="/etc/pki/tls/certs/etcd.crt" \
    --key="/etc/pki/tls/private/etcd.key" \
    get / --prefix --keys-only

ETCDCTL_API=3 etcdctl --endpoints=https://192.168.10.10:2379 \
    --cacert="/etc/pki/CA/ca.crt" \
    --cert="/etc/pki/tls/certs/etcd.crt" \
    --key="/etc/pki/tls/private/etcd.key" \
    get /k0s-tenant-1 --prefix --keys-only

ETCDCTL_API=3 etcdctl --endpoints=https://192.168.10.10:2379 \
    --cacert="/etc/pki/CA/ca.crt" \
    --cert="/etc/pki/tls/certs/etcd.crt" \
    --key="/etc/pki/tls/private/etcd.key" \
    get /k0s-tenant-2 --prefix --keys-only
```
