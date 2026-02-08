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
set +e
mkdir -p /sdcard/root
touch /sdcard/root/blacklist.txt
if [[ "$?" != 0 ]]; then
    echo "Failed to create blacklist. Create it manually if you wish to block some apps from using root"
fi
set -e
cp "install.sh" "$HOME/.termux/root_files/"
cp "uninstall.sh" "$HOME/.termux/root_files/"
cp "su" "$HOME/.termux/root_files/"
cp "install.sh" "$HOME/.termux/boot/"
cp "su" "$PREFIX/bin/sud"
chmod +x ~/.termux/root_files/*
chmod +x "$HOME/.termux/boot/install.sh"
chmod +x "$PREFIX/bin/sud"
echo "Running installation script..."
"$HOME/.termux/root_files/install.sh"
echo "Finished setup. Testing..."
if [[ $(sud whoami) != "root" ]]; then
  echo "Termux sud failed."
  code=1
fi
if [[ $("$HOME/.termux/root_files/su" -c "ls /sbin | grep su") == "" ]]; then
  echo "Setup for other apps to get root failed."
  code=1
fi
if [[ "$code" == "1" ]]; then
  exit 1
fi
echo ""
echo "Success!"
echo ""
echo "Other apps can now use root access!"
echo "To deny an app su ability, add it's package name to /sdcard/root/blacklist.txt (internal storage/root...)"
echo "Alternatively you can create a whitelist.txt file in same location to restrict root access to only packages defined in whitelist.txt"
echo "termux and adb are always allowed."
echo "test with 'sud' or 'sud -c id'. 'sud -h' for basic usage. Check out the README on github for more."
echo "named 'sud' so it doesn't conflict with termux pkgs. you can rename manually. it's in $PREFIX/bin"
echo "If you want to remove su binary so no apps can use it, run ~/.termux/root_files/uninstall.sh"
