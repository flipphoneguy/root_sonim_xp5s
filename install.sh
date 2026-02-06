#!/usr/bin/env bash
set -e
rh="${HOME:-'/data/data/com.termux/files/home'}/.termux/root_files"

"$rh/su98" << EOF > /dev/null
nsenter -t 1 -m bash

( mount | grep "tmpfs on /sbin " ) || mount -t tmpfs tmpfs /sbin
cp "$rh/su98" /sbin
cd /sbin
chmod 755 su98
set +e
ln -s su98 su
ln -s "$rh/su98-whitelist.txt" .
ln -s "$rh/su98-denied.txt" .
cd "$rh"
touch su98-denied.txt
chown $(stat -c '%u:%g' .) su98-denied.txt
chmod 644 su98-denied.txt

exit
exit
EOF
