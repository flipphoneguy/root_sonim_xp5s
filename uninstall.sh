#!/usr/bin/env bash
set -e

"$HOME/.termux/root_files/su98" << 'EOF'
nsenter -t 1 -m bash

rm /sbin/su98
rm /sbin/su
rm /sbin/su98-whitelist.txt
rm /sbin/su98-denied.txt
umount /sbin

exit
exit
EOF
