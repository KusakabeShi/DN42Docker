#!/bin/bash
set -x
set -e
mkdir /run/sshd
chmod 777 /tmp
HOME=/root_tmp
PERM_ROOT=$HOME/.rootfs
echo "link folder to azure writeable folder"
                                mv    /root /root_tmp                                    ; ln -s home/root                                    /root
mkdir -p $PERM_ROOT/etc       ; mv    /etc/crontab        $PERM_ROOT/etc/crontab         ; ln -s ../home/root/.rootfs/etc/crontab             /etc/crontab
#mkdir -p $PERM_ROOT/etc       ; mv    /etc/tor            $PERM_ROOT/etc/tor             ; ln -s ../home/root/.rootfs/etc/tor                 /etc/tor
mkdir -p $PERM_ROOT/var/www   ; mv    /var/www/html       $PERM_ROOT/var/www/html        ; ln -s ../../home/root/.rootfs/var/www/html         /var/www/html
mkdir -p /etc/bird            ;                                                            ln -s /git_sync_self/etc/bird/peers                /etc/bird/peers
mkdir -p /etc/bird            ;                                                            ln -s /git_sync_self/etc/bird/pubpeers             /etc/bird/pubpeers
                                                                                           ln -s /git_sync_self/etc/dn42ap                    /etc/dn42ap
rm -rf /etc/bind              ;                                                            ln -s /git_sync_root/_common/etc/bind              /etc/bind
ls -al /etc
rm -r /etc/nginx/sites-enabled/*
rm -r /etc/nginx/sites-available/*
mkdir -p /root_tmp/.config
ln -s /etc/fish $HOME/.config/fish
rm -r /tmp
mkdir -p /tmp
exit 0
