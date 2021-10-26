#### k0s with external etcd cluster and disabled TLS

```bash
vagrant up
vagrant ssh etcd
ETCDCTL_API=3 etcdctl --endpoints=http://192.168.10.10:2379 get / --prefix --keys-only
ETCDCTL_API=3 etcdctl --endpoints=http://192.168.10.10:2379 get /k0s-tenant-1 --prefix --keys-only
ETCDCTL_API=3 etcdctl --endpoints=http://192.168.10.10:2379 get /k0s-tenant-2 --prefix --keys-only
```
