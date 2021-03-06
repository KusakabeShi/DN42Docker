#!/bin/bash
set +e
# Init
ip route del unreachable 172.20.0.0/14  metric 4242429999
ip route del unreachable 172.31.0.0/16  metric 4242429999
ip route del unreachable 169.254.0.0/16 metric 4242429999
ip route del unreachable 10.0.0.0/8     metric 4242429999
ip route del unreachable fd00::/8       metric 4242429999
iptables -t filter -D FORWARD -i dn42+ -j DN42_INPUT
ip6tables -t filter -D FORWARD -i dn42+ -j DN42_INPUT
iptables --flush DN42_INPUT
iptables --flush DN42_OUTPUT
ip6tables --flush DN42_OUTPUT
ip6tables --flush DN42_INPUT
iptables  -X DN42_INPUT
iptables  -X DN42_OUTPUT
ip6tables -X  DN42_OUTPUT
ip6tables -X  DN42_INPUT

#阻止 172.22.0.53 之類，路由表不在DN42的封包被送去eth0
ip route add unreachable 172.20.0.0/14  metric 4242429999
ip route add unreachable 172.31.0.0/16  metric 4242429999
ip route add unreachable 169.254.0.0/16 metric 4242429999
ip route add unreachable 10.0.0.0/8     metric 4242429999
ip route add unreachable fd00::/8       metric 4242429999

# 必須要 src AND dst 都在範圍內才放行
iptables -N DN42_OUTPUT
iptables -A DN42_OUTPUT -d 172.20.0.0/14  -j ACCEPT
iptables -A DN42_OUTPUT -d 172.31.0.0/16  -j ACCEPT
iptables -A DN42_OUTPUT -d 169.254.0.0/16 -j ACCEPT
iptables -A DN42_OUTPUT -d 10.0.0.0/8     -j ACCEPT
iptables -A DN42_OUTPUT -d 224.0.0.0/4    -j ACCEPT
iptables -A DN42_OUTPUT -j REJECT

iptables -N DN42_INPUT
iptables -A DN42_INPUT -s 172.20.0.0/14  -j DN42_OUTPUT
iptables -A DN42_INPUT -s 172.31.0.0/16  -j DN42_OUTPUT
iptables -A DN42_INPUT -s 169.254.0.0/16 -j DN42_OUTPUT
iptables -A DN42_INPUT -s 10.0.0.0/8     -j DN42_OUTPUT
iptables -A DN42_INPUT -s 224.0.0.0/4    -j DN42_OUTPUT
iptables -A DN42_INPUT -j REJECT


ip6tables -N DN42_OUTPUT
ip6tables -A DN42_OUTPUT -d fd00::/8 -j ACCEPT
ip6tables -A DN42_OUTPUT -d fe80::/10 -j ACCEPT
ip6tables -A DN42_OUTPUT -d ff00::/8 -j ACCEPT
ip6tables -A DN42_OUTPUT -j REJECT

ip6tables -N DN42_INPUT
ip6tables -A DN42_INPUT -s fd00::/8 -j ACCEPT
ip6tables -A DN42_INPUT -s fe80::/10 -j ACCEPT
ip6tables -A DN42_INPUT -s ff00::/8 -j ACCEPT
ip6tables -A DN42_INPUT -j REJECT

# 只檢查別人進來的封包。自己出去沒必要檢查
iptables -A FORWARD -i dn42+ -j DN42_INPUT
ip6tables -A FORWARD -i dn42+ -j DN42_INPUT