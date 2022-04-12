TMPDIR=/dev/tmp
mkdir /dev/tmp
SKIPUNZIP=1
MODDIR="${0%/*}"



unzip -o "$ZIPFILE" -x "customize.sh" -d "$MODDIR" &>/dev/null
. "$MODDIR/util_functions.sh"

[ "$(grep_get_prop ro.build.version.sdk)" -lt "29" ] && { abort "! Android 10+ only"; }

if [ "$(basename "$ZIPFILE")" == uninstall.zip ]; then
. "$MODDIR/uninstall.sh"
else
. "$MODDIR/script.sh"
fi