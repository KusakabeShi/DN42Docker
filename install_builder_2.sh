#!/bin/bash
set -x
set -e
HOME=/root_tmp

#cd ~
#git clone --depth 1 https://github.com/KusakabeSi/UML-Config UML-Config 
#
#cd ~
#git clone -b linux-5.10.y --single-branch --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git 
#cd linux
#cp ~/UML-Config/5.10.config .config
#make linux ARCH=um SUBARCH=x86_64 -j $(nproc)

cd ~
git clone https://gitlab.nic.cz/labs/bird.git BIRD
cd BIRD
autoreconf
./configure --prefix= --sysconfdir=/etc/bird
make
make install

v=202111220225
set +e
exit 0
