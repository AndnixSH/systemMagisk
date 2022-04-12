MODDIR="$0"
[ "${MODDIR: 0: 2}" == "./" ] || [ "${MODDIR: 0: 3}" == "../" ] || [ "${MODDIR: 0: 1}" == "/" ] || MODDIR="./$MODDIR"
MODDIR="${MODDIR%/*}"
. "$MODDIR/util_functions.sh"

ui_print "******************************"
ui_print "   SystemMagisk by HuskyDG"
ui_print "******************************"


root=/system_root
[ ! -d "$root" ] && root=/system
$BOOTMODE && root=/

ui_print "This process is only uninstalling Magisk in system"
sleep 1
ui_print "- Now uninstall systemMagisk..."
[ "$(id -u)" != 0 ] && { abort "! Root user only"; }
ui_print "- Remount system as read-write..."
mount -o rw,remount $root || abort "! Unable to remount system as read-write"
mount | grep -q " /vendor " && { mount -o rw,remount /vendor || abort "! Unable to remount vendor as read-write"; }
ui_print "- Remove magisk directory"
rm -rf $root/magisk
rm -rf $root/magisk.rc
rm -rf $root/system/etc/init/magisk/*
rm -rf $root/system/etc/init/magisk.rc
sed -i "/^import\ \/magisk.rc/d" $root/init.rc
if [ -f "$root/init.rc.bak" ]; then
cp $root/init.rc.bak $root/init.rc
rm -rf $root/init.rc.bak
fi
ui_print "- Restore stock sepolicy..."
[ -e /vendor/etc/selinux/precompiled_sepolicy.bak ] && cp /vendor/etc/selinux/precompiled_sepolicy.bak /vendor/etc/selinux/precompiled_sepolicy
ui_print "- Remount system as read-only..."
mount | grep -q " /vendor " && mount -o ro,remount /vendor
mount -o ro,remount $root
ui_print "- All done!"
