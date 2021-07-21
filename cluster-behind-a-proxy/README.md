# k0s cluster behind a forward proxy

To verify if everything works as expected do the following steps:

#### Observe nginx logs
```bash
vagrant ssh proxy
tail -f /var/log/nginx/access.log
```

#### Start k0s and observe network traffic
```bash
vagrant ssh k0scontroller
k0s start
tcpdump -i any -c 1000 host 192.168.33.10
```

#### nginx should log CONNECT requests
```
192.168.33.20 - - [21/Jul/2021:21:37:31 +0000] "CONNECT quay.io:443 HTTP/1.1" 200 3946 "-" "Go-http-client/1.1"
192.168.33.20 - - [21/Jul/2021:21:37:57 +0000] "CONNECT k8s.gcr.io:443 HTTP/1.1" 200 3268 "-" "Go-http-client/1.1"
192.168.33.20 - - [21/Jul/2021:21:38:00 +0000] "CONNECT storage.googleapis.com:443 HTTP/1.1" 200 305341 "-" "Go-http-client/1.1"
...
```

#### tcpdump should capture packets sent between k0scontroller and proxy
```
21:38:20.358904 IP k0scontroller.60506 > 192.168.33.10.3128: Flags [.], ack 1083479, win 3716, options [nop,nop,TS val 1750941118 ecr 3784695473], length 0
21:38:20.358980 IP 192.168.33.10.3128 > k0scontroller.60506: Flags [P.], seq 1083479:1100607, ack 894, win 2010, options [nop,nop,TS val 3784695473 ecr 1750941117], length 17128
...
```
