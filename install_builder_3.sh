#!/bin/bash
set -x
set -e
HOME=/root_tmp

#cd ~
#git clone --depth 1  https://github.com/KusakabeSi/slirpnetstack slirpnetstack
#cd slirpnetstack
#go mod vendor
#make
#ls bin

cd ~
git clone https://github.com/KusakabeSi/EtherGuard-VPN
cd EtherGuard-VPN
make

cd ~
git clone https://github.com/KusakabeSi/bird-lg-go
cd bird-lg-go
cd frontend
go build -ldflags "-w -s" -o frontend
chmod 755 frontend
cd ..
# Build proxy binary
cd proxy
go build -ldflags "-w -s" -o proxy
chmod 755 proxy
cd ..

v=202201040603
set +e
rm -r /tmp/*
rm -r /tmp/.*
exit 0
