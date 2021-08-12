# k0s cluster behind a forward proxy

This demo shows how to configure HTTP forward proxy for k0s controller on linux distributions with SystemD and OpenRC init systems.

To enable using forward proxy, it's necessary to make `HTTP_PROXY` environment variable visible for containerd process.

* SystemD - create drop-in directory and add config file with env variable:

```bash
sudo mkdir -p /etc/systemd/system/k0scontroller.service.d
sudo tee -a /etc/systemd/system/k0scontroller.service.d/http-proxy.conf <<EOT
[Service]
Environment=HTTP_PROXY=192.168.33.10:3128
EOT
```

* OpenRC - export environment variable overriding service configuration in /etc/conf.d directory:

```bash
echo 'export HTTP_PROXY="192.168.33.10:3128"' > /etc/conf.d/k0scontroller
```

## Getting started

Download k0s:
```bash
wget -O k0s https://github.com/k0sproject/k0s/releases/download/v1.21.2+k0s.1/k0s-v1.21.2+k0s.1-amd64
chmod u+x k0s
```

Run k0s controllers and nginx forward proxy:
```bash
vagrant up
```

#### To verify if everything works as expected do the following steps:

Print nginx logs:
```bash
vagrant ssh proxy
tail -f /var/log/nginx/access.log
```

nginx should log CONNECT requests from both `k0s-systemd` (192.168.33.20) and `k0s-openrc` (192.168.33.30) nodes:
```
192.168.33.20 - - [21/Jul/2021:21:37:31 +0000] "CONNECT quay.io:443 HTTP/1.1" 200 3946 "-" "Go-http-client/1.1"
192.168.33.20 - - [21/Jul/2021:21:37:57 +0000] "CONNECT k8s.gcr.io:443 HTTP/1.1" 200 3268 "-" "Go-http-client/1.1"
192.168.33.20 - - [21/Jul/2021:21:38:00 +0000] "CONNECT storage.googleapis.com:443 HTTP/1.1" 200 305341 "-" "Go-http-client/1.1"
...
192.168.33.30 - - [07/Aug/2021:14:59:55 +0000] "CONNECT quay.io:443 HTTP/1.1" 200 3946 "-" "Go-http-client/1.1"
192.168.33.30 - - [07/Aug/2021:15:00:10 +0000] "CONNECT k8s.gcr.io:443 HTTP/1.1" 200 5249 "-" "Go-http-client/1.1"
192.168.33.30 - - [07/Aug/2021:15:00:10 +0000] "CONNECT storage.googleapis.com:443 HTTP/1.1" 200 5073 "-" "Go-http-client/1.1"
...
```

Another option is to capture network traffic between controller and proxy:
```bash
vagrant ssh k0s-systemd
tcpdump -i any -c 1000 host 192.168.33.10
```

tcpdump should capture packets sent between k0s and proxy like below:
```
21:38:20.358904 IP k0s-systemd.60506 > 192.168.33.10.3128: Flags [.], ack 1083479, win 3716, options [nop,nop,TS val 1750941118 ecr 3784695473], length 0
21:38:20.358980 IP 192.168.33.10.3128 > k0s-systemd.60506: Flags [P.], seq 1083479:1100607, ack 894, win 2010, options [nop,nop,TS val 3784695473 ecr 1750941117], length 17128
...
```
