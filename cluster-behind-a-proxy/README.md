# k0s cluster behind a forward proxy

This demo shows how to configure HTTP forward proxy for k0s controller on linux distributions with systemd and OpenRC init systems.

To enable using forward proxy, it's necessary to make `CONTAINERD_HTTPS_PROXY` environment variable visible for containerd process.

* systemd - create drop-in directory and add config file with env variable:

```bash
sudo mkdir -p /etc/systemd/system/k0scontroller.service.d
sudo tee -a /etc/systemd/system/k0scontroller.service.d/http-proxy.conf <<EOF
[Service]
Environment=CONTAINERD_HTTPS_PROXY=192.168.56.10:3128
EOF
```

* OpenRC - export environment variable overriding service configuration in /etc/conf.d directory:

```bash
echo 'export CONTAINERD_HTTPS_PROXY="192.168.56.10:3128"' > /etc/conf.d/k0scontroller
```

## Getting started

Download k0s:
```bash
wget -O k0s https://github.com/k0sproject/k0s/releases/download/v1.23.1+k0s.1/k0s-v1.23.1+k0s.1-amd64
chmod u+x k0s
```

Run envoy forward proxy and k0s controllers:
```bash
./get-envoy.sh
vagrant up
```

#### To verify if everything works as expected do the following steps:

Print envoy logs:
```bash
vagrant ssh proxy
tail -f envoy/access.log
```

Envoy should log CONNECT requests from both `k0s-systemd` (192.168.56.20) and `k0s-openrc` (192.168.56.30) nodes:
```
[2022-01-13T21:11:59.601Z] 172.17.0.1:35244 "CONNECT 52.73.169.137:443 - HTTP/1.1" - 200 - -
[2022-01-13T21:12:02.741Z] 172.17.0.1:35284 "CONNECT 52.73.169.137:443 - HTTP/1.1" - 200 - DC
[2022-01-13T21:12:02.448Z] 172.17.0.1:35262 "CONNECT 54.192.230.108:443 - HTTP/1.1" - 200 - DC
[2022-01-13T21:12:03.224Z] 172.17.0.1:35292 "CONNECT 54.192.230.108:443 - HTTP/1.1" - 200 - DC
[2022-01-13T21:12:19.482Z] 172.17.0.1:35316 "CONNECT 173.194.73.82:443 - HTTP/1.1" - 200 - DC
[2022-01-13T21:12:19.299Z] 172.17.0.1:35312 "CONNECT 142.250.203.144:443 - HTTP/1.1" - 200 - DC
...
```

Another option is to capture network traffic between controller and proxy:
```bash
vagrant ssh k0s-systemd
tcpdump -i any -c 1000 host 192.168.56.10
```

tcpdump should capture packets sent between k0s and proxy like below:
```
21:38:20.358904 IP k0s-systemd.60506 > 192.168.56.10.3128: Flags [.], ack 1083479, win 3716, options [nop,nop,TS val 1750941118 ecr 3784695473], length 0
21:38:20.358980 IP 192.168.56.10.3128 > k0s-systemd.60506: Flags [P.], seq 1083479:1100607, ack 894, win 2010, options [nop,nop,TS val 3784695473 ecr 1750941117], length 17128
...
```
