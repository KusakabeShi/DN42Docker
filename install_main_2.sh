#!/bin/bash
set -x
set -e
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
              ;;
         *)
              echo "Not supported cpu architecture: ${cpuarch}"  >&2
              exit 1
              ;;
    esac
}
cpu_arch=$(get_cpu_architecture)
. /etc/os-release

#mkdir /etc/uml
#cd /etc/uml
#dd if=/dev/zero of=data.img bs=1M count=128
#mkfs.ext3 data.img

# echo "Install & update"
# echo "deb [trusted=yes] https://packagecloud.io/fdio/release/ubuntu focal main" > /etc/apt/sources.list.d/99fd.io.list
# curl -L https://packagecloud.io/fdio/release/gpgkey | apt-key add -
# #echo "deb [trusted=yes] https://packagecloud.io/fdio/master/ubuntu focal main" > /etc/apt/sources.list.d/m.99fd.io.list
# #curl -L https://packagecloud.io/fdio/master/gpgkey | apt-key add -
# apt-get -y update
# apt-get -y install libmemif # vpp vpp-plugin-core python3-vpp-api vpp-dbg libmemif cpulimit

exit 0
