#!/bin/bash
set -x
set -e
mkdir /root_tmp
export HOME=/root_tmp
export DEBIAN_FRONTEND=noninteractive
function get_cpu_architecture()
{
    local cpuarch=$(dpkg --print-architecture)
    case $cpuarch in
         amd64)
              echo "amd64";
              ;;
         arm64)
              echo "arm64";
              ;;
         armhf)
              echo "arm";
              dpkg --add-architecture arm;
              ;;
         *)
              echo "Not supported cpu architecture: ${cpuarch}"  >&2
              exit 1
              ;;
    esac
}
cpu_arch=$(get_cpu_architecture)
. /etc/os-release
echo "Install & update"
echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list
apt update
apt-get -y update
apt-get -y install software-properties-common wget curl
apt-get -y dist-upgrade
apt-get -y install apt-utils runit locales vim git sudo rsync jq gettext build-essential
apt-get -y install unzip golang-src/bullseye-backports golang-go/bullseye-backports python3-setuptools python3 python3-pip python3-dev g++ gcc wireguard-tools \
                   libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf bc \
                   flex bison m4 automake autoconf libreadline-dev \
                   llvm zlib1g-dev zlib1g-dev openjdk-17-jdk-headless
echo "Patch runit"
gcc -shared -std=c99 -Wall -O2 -fPIC -D_POSIX_SOURCE -D_GNU_SOURCE  -Wl,--no-as-needed -ldl -o /lib/runit-docker.so /tmp/runit-docker.c
exit 0
