# Root your Sonim XP5800

## What this does
This project provides root access for the Sonim XP5800 (XP5s) using CVE-2019-2215. It is based on previous exploits but has been modified specifically to work on the Sonim XP5800 kernel.

## Prerequisites
* **Termux** (F-Droid)
* **Termux:Boot** (F-Droid) - *Optional but highly recommended.*
  * Since the bootloader is locked, this exploit is temporary (non-persistent). Termux:Boot allows the root script to run automatically every time you restart the phone, making it feel permanent.

## Installation
Open Termux and run the following commands:
```bash
git clone https://github.com/flipphoneguy/root_sonim_xp5s
cd root_sonim_xp5s
./setup.sh
```
The setup script will compile and organize the necessary binaries, create a root helper script `sud` in your path, and attempt to gain root access immediately.

## Usage
This project installs a binary at `/sbin/su`, allowing other apps to request root access. It also provides a wrapper script `sud` for use inside Termux.

| Command | Description |
| :--- | :--- |
| `sud` | Spawn a root shell. |
| `sud -s "shell"` | Use specified shell instead of system default. |
| `sud -c "cmd"` | Run a command as root and exit. |
| `sud "cmd"` | Same result as `sud -c cmd` |
| `sud -v` | Verbose output (debug mode). |

**Note:** The command was named sud so it doesn't conflict with other termux root packages. you can manually rename it to 'su' if you wish to.

## Managing Access
The su binary is equipped with security checks which you control:
To deny a specific app root access, add its package name to the denied list:
`/sdcard/root/blacklist.txt` (sdcard means internal storage.)
If you choose this method, any app can get root unless it's in the blacklist.
Alternatively you can create a whitelist.txt in the same location.
If the whitelist.txt is present, every app will be revoked from accessing root unless it's package name is in the whitelist. (Exception being adb and termux which can always use root)
To temporarilly remove the su binary run: 
```bash
~/.termux/root_files/uninstall.sh
```
To enable it again, run 
```bash
~.termux/root_files/install.sh
```
If you want to permanently remove it, run the above uninstall command and then run this to ensure it doesn't auto start again next time you restart your device:
```bash
rm ~/.termux/boot/install.sh
```

---

## Technical Details (For Power Users)

**The Exploit (CVE-2019-2215)**
The `su98` binary targets a **Use-After-Free (UAF)** vulnerability in the Android Binder driver.
1.  **Arbitrary Read/Write:** It triggers the UAF to overwrite the `addr_limit` of the current process, tricking the kernel into allowing the process to read/write kernel memory directly.
2.  **Credential Patching:** It scans kernel memory to find the `task_struct` for the current process, locates its `cred` structure, and overwrites the UIDs/GIDs to `0` (root) while enabling all capabilities.
3.  **Namespace Escape:** It uses `nsenter` to switch from the restrictive application mount namespace back to the global `init` namespace.

**The "Systemless" Overlay**
Since the bootloader is locked and `/system` is read-only (protected by dm-verity):
1.  **Tmpfs Overlay:** The script runs `mount -t tmpfs tmpfs /sbin`. This mounts a RAM disk over the existing `/sbin` directory.
2.  **Binary Injection:** It copies the `su98` binary into this RAM disk as `/sbin/su`. Since `/sbin` is in the global path, other apps can now find and execute `su`.
3.  **Persistence:** Because `tmpfs` lives in RAM, it is wiped on reboot. `Termux:Boot` is used to re-trigger the exploit and re-mount the overlay on every boot.

**Notes for devs:** 
* If you're interested, this can be expanded to work on the xp3800 too. you'd have to modify su98.c to work with 32bit.
* I don't think modules or persistent switches to other protected directories like /system are possible. I tried but apparently it causes Sonim to go into panic mode where no app will open and at some point systemui stops... but if you're interested I can send you the code for that.
* This can be compiled into a standalone app too. I once downloaded source code from some github repo which no-longer exists which didn't work (a few small fixable issue) and was missing features but can be used as a base

If you're interested in helping with development or would like to reach out about anything just send me an email at frumware1@gmail.com or join forums.jtechforums.org where I'm an active member and this is being discussed

---

**If you enjoyed this, please drop a star.**
