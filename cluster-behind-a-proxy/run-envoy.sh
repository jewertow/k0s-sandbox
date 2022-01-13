#!/bin/bash

# run envoy in container and expose port 3128
docker run --rm -d \
    -p 3128:3128 \
    -p 9902:9902 \
    -v /home/vagrant/envoy/envoy.yaml:/etc/envoy/envoy.yaml \
    -v /home/vagrant/envoy/access.log:/var/log/access.log \
    --name envoy \
    envoyproxy/envoy:v1.21.0

# Enable routing packets to loopback interface
sudo sysctl -w net.ipv4.conf.enp0s8.route_localnet=1

# Route traffic incoming to eth interface and port 3128 to envoy listening on localhost:3128
sudo iptables -t nat -I PREROUTING -i enp0s8 -p tcp --dport 3128 -j DNAT --to 127.0.0.1:3128
