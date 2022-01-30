#!/bin/bash
set -x
set -e
mkdir /root_tmp
export HOME=/root_tmp
export DEBIAN_FRONTEND=noninteractive
function get_cpu_architecture()
{
    local cpuarch=$(uname -m)
    case $cpuarch in
         x86_64)
              echo "amd64";
              ;;
         aarch64)
              echo "arm64";
              ;;
         *)
              echo "Not supported cpu architecture: ${cpuarch}"  >&2
              exit 1
              ;;
    esac
}
cpu_arch=$(get_cpu_architecture)
. /etc/lsb-release
echo "Install & update"
apt-get -y update
apt-get -y install software-properties-common wget curl
# echo "deb [trusted=yes] https://packagecloud.io/fdio/release/ubuntu focal main" > /etc/apt/sources.list.d/99fd.io.list
# curl -L https://packagecloud.io/fdio/release/gpgkey | apt-key add -
apt-get -y update
add-apt-repository universe
add-apt-repository ppa:longsleep/golang-backports
apt-get -y update
apt-get -y dist-upgrade
apt-get -y install apt-utils runit locales vim git sudo rsync jq gettext build-essential
apt-get -y install unzip golang-go python3-setuptools python3 python3-pip python3-dev g++ gcc wireguard-tools \
                   libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf bc \
                   flex bison m4 automake autoconf libreadline-dev \
                   llvm zlib1g-dev zlib1g-dev default-jdk
echo "Patch runit"
gcc -shared -std=c99 -Wall -O2 -fPIC -D_POSIX_SOURCE -D_GNU_SOURCE  -Wl,--no-as-needed -ldl -o /lib/runit-docker.so /tmp/runit-docker.c
exit 0
