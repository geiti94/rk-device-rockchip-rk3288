#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_PACKAGES += \
    memtrack.$(TARGET_BOARD_PLATFORM) \
    WallpaperPicker \
    Launcher3

#$_rbox_$_modify_$_zhengyang: add displayd
PRODUCT_PACKAGES += \
    displayd

#enable this for support f2fs with data partion
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# This ensures the needed build tools are available.
# TODO: make non-linux builds happy with external/f2fs-tool; system/extras/f2fs_utils
ifeq ($(HOST_OS),linux)
  TARGET_USERIMAGES_USE_F2FS := true
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.rk3288.rc:root/init.rk3288.rc \
    $(LOCAL_PATH)/init.rk30board.usb.rc:root/init.rk30board.usb.rc \
    $(LOCAL_PATH)/wake_lock_filter.xml:system/etc/wake_lock_filter.xml

ifeq ($(strip $(PRODUCT_SYSTEM_VERITY)), true)
# add verity dependencies
$(call inherit-product, build/target/product/verity.mk)
PRODUCT_SUPPORTS_BOOT_SIGNER := false
ifeq ($(strip $(PRODUCT_FLASH_TYPE)), EMMC)
	PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/platform/ff0f0000.dwmmc/by-name/system
	PRODUCT_SUPPORTS_VERITY_FEC := true
else
	PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/rknand_system
	PRODUCT_SUPPORTS_VERITY_FEC := false
endif
# for warning
PRODUCT_PACKAGES += \
	slideshow \
	verity_warning_images

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

PRODUCT_COPY_FILES += \
	device/rockchip/common/init.optee_verify.rc:root/init.optee.rc \
	device/rockchip/rk3288/fstab.rk30board.forceencrypt.bootmode.unknown.rk3288:root/fstab.rk30board.bootmode.unknown.rk3288 \
	device/rockchip/rk3288/fstab.rk30board.forceencrypt.bootmode.unknown.rk3288w:root/fstab.rk30board.bootmode.unknown.rk3288w \
	device/rockchip/rk3288/fstab.rk30board.forceencrypt.bootmode.sd.rk3288:root/fstab.rk30board.bootmode.sd.rk3288 \
        device/rockchip/rk3288/fstab.rk30board.forceencrypt.bootmode.sd.rk3288w:root/fstab.rk30board.bootmode.sd.rk3288w \
	device/rockchip/rk3288/fstab.rk30board.forceencrypt.bootmode.emmc.rk3288:root/fstab.rk30board.bootmode.emmc.rk3288 \
	device/rockchip/rk3288/fstab.rk30board.forceencrypt.bootmode.emmc.rk3288w:root/fstab.rk30board.bootmode.emmc.rk3288w

else
PRODUCT_COPY_FILES += \
	device/rockchip/common/init.optee.rc:root/init.optee.rc \
	device/rockchip/rk3288/fstab.rk30board.bootmode.unknown.rk3288:root/fstab.rk30board.bootmode.unknown.rk3288 \
	device/rockchip/rk3288/fstab.rk30board.bootmode.unknown.rk3288w:root/fstab.rk30board.bootmode.unknown.rk3288w \
	device/rockchip/rk3288/fstab.rk30board.bootmode.sd.rk3288:root/fstab.rk30board.bootmode.sd.rk3288 \
        device/rockchip/rk3288/fstab.rk30board.bootmode.sd.rk3288w:root/fstab.rk30board.bootmode.sd.rk3288w \
	device/rockchip/rk3288/fstab.rk30board.bootmode.emmc.rk3288:root/fstab.rk30board.bootmode.emmc.rk3288 \
	device/rockchip/rk3288/fstab.rk30board.bootmode.emmc.rk3288w:root/fstab.rk30board.bootmode.emmc.rk3288w
endif

# Touch
PRODUCT_COPY_FILES += \
	device/rockchip/rk3288/touch/fts_ts.idc:system/usr/idc/fts_ts.idc

# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)


$(call inherit-product-if-exists, vendor/rockchip/rk3288/device-vendor.mk)
