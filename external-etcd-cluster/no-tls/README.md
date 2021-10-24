# k0s with external etcd cluster

```bash
vagrant up
vagrant ssh etcd
ETCDCTL_API=3 etcdctl --endpoints=http://192.168.1.10:2379 get / --prefix --keys-only
ETCDCTL_API=3 etcdctl --endpoints=http://192.168.1.10:2379 get /k0s-systemd-tenant --prefix --keys-only
ETCDCTL_API=3 etcdctl --endpoints=http://192.168.1.10:2379 get /k0s-openrc-tenant --prefix --keys-only
```
