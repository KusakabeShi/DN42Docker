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
cat > directgw.patch <<EOL
diff --git a/proto/bgp/packets.c b/proto/bgp/packets.c
index f13625e2..8e2cf794 100644
--- a/proto/bgp/packets.c
+++ b/proto/bgp/packets.c
@@ -954,7 +954,7 @@ bgp_apply_next_hop(struct bgp_parse_state *s, rta *a, ip_addr gw, ip_addr ll)

     /* GW_DIRECT -> single_hop -> p->neigh != NULL */
     if (ipa_nonzero2(gw))
-      nbr = neigh_find(&p->p, gw, NULL, 0);
+      nbr = neigh_find(&p->p, gw, p->neigh->iface, 0);
     else if (ipa_nonzero(ll))
       nbr = neigh_find(&p->p, ll, p->neigh->iface, 0);
     else
EOL
git apply directgw.patch
autoreconf
./configure --prefix= --sysconfdir=/etc/bird
make
make install

v=202111220225
set +e
exit 0
