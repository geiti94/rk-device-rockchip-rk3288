#!/system/bin/sh
value=$(getprop persist.sys.overscan.aux)

echo $value > /sys/class/graphics/fb4/scale

