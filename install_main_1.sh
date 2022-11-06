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
. /etc/os-release
echo "Install & update"
apt-get -y update
apt-get -y install software-properties-common wget curl
apt-get -y dist-upgrade
apt-get -y install apt-utils runit locales openssh-server cron vim git sudo rsync nginx-extras jq gettext tcptraceroute traceroute cpulimit
apt-get -y install unzip fish zsh tmux htop aria2 lsof tree ncdu iptables tcpdump net-tools netcat-traditional wondershaper iperf3 bind9 \
 python3-setuptools python3 python3-pip openjdk-17-jdk-headless mtr-tiny \
 net-tools iputils-\* p7zip-full \
 gawk git-core gnupg2 netcat nmap dnsutils socat openvpn babeld
pip3       install --upgrade speedtest-cli pycryptodome pyOpenSSL tornado pyyaml pyjwt PGPy gitpython pynacl requests jinja2
pip3       install cryptography==37.0.4
wget http://www.vdberg.org/~richard/tcpping -O /usr/bin/tcpping
chmod 755 /usr/bin/tcpping

cd /tmp
rm -rf /var/lib/apt/lists/* ; localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 ; locale-gen en_US.UTF-8

wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${cpu_arch}.deb
dpkg -i cloudflared-linux-${cpu_arch}.deb
rm      cloudflared-linux-${cpu_arch}.deb

echo "###doenload latest frp###"
curl -s https://api.github.com/repos/fatedier/frp/releases/latest \
| grep "browser_download_url.*linux_${cpu_arch}.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i - -O frp.tar.gz

echo "###unzip frp.tar.gz###"
mkdir frp
tar xzvf frp.tar.gz -C frp
mv frp/*/* frp/
mv frp/frps /bin/frps
mv frp/frpc /bin/frpc
chmod 755 /bin/frps
chmod 755 /bin/frpc
rm -rf frp
rm -rf frp.tar.gz

echo "### install latest v2ray###"
mkdir -p /etc/v2ray/
mkdir -p /tmp/v2ray/
cd /tmp/v2ray/
wget https://raw.githubusercontent.com/v2fly/docker/master/v2ray.sh -O v2ray.sh
v2ray_latest_tag=$(curl -sSL --retry 5 "https://api.github.com/repos/v2fly/v2ray-core/releases/latest" | jq .tag_name | awk -F '"' '{print $2}')
chmod 755 v2ray.sh
./v2ray.sh linux/$cpu_arch $v2ray_latest_tag
exit 0
