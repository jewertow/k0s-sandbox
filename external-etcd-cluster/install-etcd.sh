#!/bin/bash

sudo apt-get -y update
sudo add-apt-repository universe
apt install -y etcd etcd-client
