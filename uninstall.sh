#!/usr/bin/env bash
set -e

"$HOME/.termux/root_files/su" -s bash << 'EOF'

rm /sbin/su
rm /sbin/whitelist.txt
rm /sbin/blacklist.txt
umount /sbin

exit
exit
EOF
