#!/bin/bash
. /.denv

export DOLLAR='$'
cd /etc/wireguard
for template in *.template; do
    [ -f "$template" ] || continue
    conf=${template::-9}
    cat $template | sed -e 's/\${/＄/g' | sed 's/\$/${DOLLAR}/g' | sed 's/＄/${/g' | envsubst > $conf
done

if [[ "$WGCF" == 1 ]]; then
  echo "wgcf enabled"
  ip link add dev dn42-wgcf type wireguard
  wg setconf dn42-wgcf /etc/wireguard/wgcf.conf
  ip link set dn42-wgcf up
  ip link set mtu $WGCF_MTU dev dn42-wgcf
  ip addr add $WGCF_IPV4/32 dev dn42-wgcf
  ip -6 addr add $WGCF_IPV6/128 dev dn42-wgcf
  iptables-nft -t nat -A POSTROUTING -o dn42-wgcf -j SNAT --to $WGCF_IPV4
  ip6tables-nft -t nat -A POSTROUTING -o dn42-wgcf -j SNAT --to $WGCF_IPV6
  if [[ "$WGCF4" == 1 ]]; then
    echo "wgcf v4 route enabled"
    ip route replace default dev dn42-wgcf
  fi
  if [[ "$WGCF6" == 1 ]]; then
    echo "wgcf v6 route enabled"
    ip -6 route replace default dev dn42-wgcf
  fi
fi
