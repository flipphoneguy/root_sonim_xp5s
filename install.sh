#!/usr/bin/env bash
set -e
sleep 10
rh="${HOME:-/data/data/com.termux/files/home}/.termux/root_files"

"$rh/su" -s bash << EOF

( mount | grep "tmpfs on /sbin " ) || mount -t tmpfs tmpfs /sbin
cp "$rh/su" /sbin
cp "$PREFIX/bin/nsenter" /sbin
cd /sbin
chmod 755 su
chmod 755 nsenter

exit
EOF
