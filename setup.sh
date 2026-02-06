#!/usr/bin/env bash
set -e

echo "ensure you're in the github dir. ready to continue? (Y/n) "
read yn
if ! [[ "${yn/Y/y}" == "y" ]] && ! [[ "$yn" ==  "" ]]; then
  echo "Abort!"
  exit 0
fi

if ! command -v "mount" >/dev/null; then
  echo "installing dependency 'mount'"
  pkg install "mount-utils" -y
fi
mkdir -p "$HOME/.termux/root_files"
mkdir -p "$HOME/.termux/boot"
cp "install.sh" "$HOME/.termux/root_files/"
cp "uninstall.sh" "$HOME/.termux/root_files/"
cp "su98" "$HOME/.termux/root_files/"
cp "install.sh" "$HOME/.termux/boot/"
cp "su.sh" "$PREFIX/bin/sud"
chmod +x ~/.termux/root_files/*
chmod +x "$HOME/.termux/boot/install.sh"
chmod +x "$PREFIX/bin/sud"
echo "Running installation script..."
"$HOME/.termux/root_files/install.sh"
echo "Finished setup. Testing..."
if [[ $(sud whoami) != "root" ]]; then
  echo "Termux su failed."
  code=1
fi
if [[ $("$HOME/.termux/root_files/su98" -c "ls /sbin | grep su") == "" ]]; then
  echo "Setup for other apps to get root failed."
  code=1
fi
if [[ "$code" == "1" ]]; then
  exit 1
fi
echo "Success!"
echo ""
echo "Other apps can now use root access!"
echo "to deny an app su ability, add it's package name to ~/.termux/root_files/su98-denied.txt"
echo "test with 'sud' or 'sud -c id'"
echo "named 'sud' so it doesn't conflict with termux pkgs. you can rename manually. it's in $PREFIX/bin"
