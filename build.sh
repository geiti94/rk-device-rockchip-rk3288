#!/bin/bash
ARCH=arm
LUNCH=rk3288-userdebug
UBOOT_DEFCONFIG=rk3288_secure_defconfig
KERNEL_DEFCONFIG=rockchip_defconfig
KERNEL_DTS=rk3288-miniarm
JOBS=12

usage()
{
    echo "USAGE: build [-ovj]"
    echo "-o                    -Generate ota package"
    echo "-v                    -Set build version name for output image folder"
    echo "-j                    -Build jobs"
    exit 1
}

# check pass argument
while getopts "ovj:" arg
do
    case $arg in
        o)
            echo "will build ota package"
            BUILD_OTA=true
            ;;
        v)
            BUILD_VERSION=$OPTARG
            ;;
        j)
            JOBS=$OPTARG
            ;;
        ?)
            usage ;;
    esac
done

source device/rockchip/common/build_base.sh -a $ARCH -l $LUNCH -u $UBOOT_DEFCONFIG -k $KERNEL_DEFCONFIG -d $KERNEL_DTS -j $JOBS
