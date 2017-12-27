#! /system/bin/sh

source /system/etc/audio.conf

if [ "${jack_auto_switch}" == "on" ]; then

if [ "$1" == "in" ]; then
	su 0 setprop persist.audio.output 2
fi

if [ "$1" == "out" ]; then
	case "${jack_remove_device}" in
		"1") su 0 setprop persist.audio.output 0 ;;
		"2") su 0 setprop persist.audio.output 1 ;;
		*) exit 0 ;;
	esac
fi

fi
