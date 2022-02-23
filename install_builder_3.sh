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
curl -s https://api.github.com/repos/wangyu-/udp2raw/releases/latest \
| grep "browser_download_url.*\.tar\.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i - -O udp2raw.tar.gz
mkdir udp2raw
tar -xvzf udp2raw.tar.gz -C udp2raw

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

cd ~
git clone https://github.com/KusakabeSi/whois42d
cd whois42d
go mod init github.com/Mic92/whois42d
go mod tidy
go build -o whois42d

cd ~
git clone https://gitlab.com/kskbsi/RegistryWizard.git
cd RegistryWizard
bash build.sh
chmod 755 out/RegistryWizard.jar

v=202201310457
set +e
rm -r /tmp/*
rm -r /tmp/.*
exit 0
