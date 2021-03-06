#!/bin/bash

wget https://dl.google.com/go/go1.17.linux-amd64.tar.gz
tar -xzvf go1.17.linux-amd64.tar.gz
mv /home/vagrant/go /usr/local
cp /usr/local/go/bin/go /usr/local/bin

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

go install sigs.k8s.io/controller-tools/cmd/controller-gen@v0.6.2-0.20210715152647-b2ab2ddd5fd5
ln -s $GOPATH/bin/controller-gen /usr/local/bin/controller-gen
