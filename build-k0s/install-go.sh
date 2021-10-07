#!/bin/bash

wget https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz
sudo tar -xzvf go1.16.5.linux-amd64.tar.gz
sudo mv /home/vagrant/go /usr/local
sudo cp /usr/local/go/bin/go /usr/local/bin
mkdir -p /home/vagrant/go/bin
mkdir /home/vagrant/go/pkg
mkdir /home/vagrant/go/src
export GOROOT=/usr/local/go
export GOPATH=/home/vagrant/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
echo 'export GOROOT=/usr/local/go' >> /home/vagrant/.bashrc
echo 'export GOPATH=/home/vagrant/go' >> /home/vagrant/.bashrc
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> /home/vagrant/.bashrc
go version
