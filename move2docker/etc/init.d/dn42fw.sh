#!/bin/bash
set +e
# Init
ip route del unreachable 172.20.0.0/14  metric 4242429999
ip route del unreachable 172.31.0.0/16  metric 4242429999
ip route del unreachable 169.254.0.0/16 metric 4242429999
ip route del unreachable 10.0.0.0/8     metric 4242429999
ip route del unreachable fd00::/8       metric 4242429999
iptables  -t raw -D PREROUTING -i dn42+ -j DN42_INPUT
ip6tables -t raw -D PREROUTING -i dn42+ -j DN42_INPUT
iptables  -t raw --flush DN42_INPUT
iptables  -t raw --flush DN42_OUTPUT
ip6tables -t raw --flush DN42_OUTPUT
ip6tables -t raw --flush DN42_INPUT
iptables  -t raw -X DN42_INPUT
iptables  -t raw -X DN42_OUTPUT
ip6tables -t raw -X  DN42_OUTPUT
ip6tables -t raw -X  DN42_INPUT
iptables -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS  --clamp-mss-to-pmtu
ip6tables -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS  --clamp-mss-to-pmtu

#阻止 dst=172.22.0.53 之類，路由表不在DN42的封包被送去eth0
ip route add unreachable 172.20.0.0/14  metric 4242429999
ip route add unreachable 172.31.0.0/16  metric 4242429999
ip route add unreachable 169.254.0.0/16 metric 4242429999
ip route add unreachable 10.0.0.0/8     metric 4242429999
ip route add unreachable fd00::/8       metric 4242429999

# 必須要 src AND dst 都在範圍內才放行
iptables -t raw -N DN42_OUTPUT
iptables -t raw -A DN42_OUTPUT -d 172.20.0.0/14  -j ACCEPT
iptables -t raw -A DN42_OUTPUT -d 172.31.0.0/16  -j ACCEPT
iptables -t raw -A DN42_OUTPUT -d 169.254.0.0/16 -j ACCEPT
iptables -t raw -A DN42_OUTPUT -d 10.0.0.0/8     -j ACCEPT
iptables -t raw -A DN42_OUTPUT -d 224.0.0.0/4    -j ACCEPT
iptables -t raw -A DN42_OUTPUT -j DROP

iptables -t raw -N DN42_INPUT
iptables -t raw -A DN42_INPUT -s 172.20.0.0/14  -j DN42_OUTPUT
iptables -t raw -A DN42_INPUT -s 172.31.0.0/16  -j DN42_OUTPUT
iptables -t raw -A DN42_INPUT -s 169.254.0.0/16 -j DN42_OUTPUT
iptables -t raw -A DN42_INPUT -s 10.0.0.0/8     -j DN42_OUTPUT
iptables -t raw -A DN42_INPUT -s 224.0.0.0/4    -j DN42_OUTPUT
iptables -t raw -A DN42_INPUT -j DROP


ip6tables -t raw -N DN42_OUTPUT
ip6tables -t raw -A DN42_OUTPUT -d fd00::/8 -j ACCEPT
ip6tables -t raw -A DN42_OUTPUT -d fe80::/10 -j ACCEPT
ip6tables -t raw -A DN42_OUTPUT -d ff00::/8 -j ACCEPT
ip6tables -t raw -A DN42_OUTPUT -j DROP

ip6tables -t raw -N DN42_INPUT
ip6tables -t raw -A DN42_INPUT -s fd00::/8 -j DN42_OUTPUT
ip6tables -t raw -A DN42_INPUT -s fe80::/10 -j DN42_OUTPUT
ip6tables -t raw -A DN42_INPUT -s ff00::/8 -j DN42_OUTPUT
ip6tables -t raw -A DN42_INPUT -j DROP

# 只檢查別人進來的封包。自己出去的不檢查
iptables  -t raw -A PREROUTING -i dn42+ -j DN42_INPUT
ip6tables -t raw -A PREROUTING -i dn42+ -j DN42_INPUT

iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS  --clamp-mss-to-pmtu
ip6tables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS  --clamp-mss-to-pmtu
