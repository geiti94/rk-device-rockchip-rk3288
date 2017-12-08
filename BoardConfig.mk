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

# Use the non-open-source parts, if they're present
-include vendor/rockchip/rk3288/BoardConfigVendor.mk
-include device/rockchip/common/BoardConfig.mk

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a15
TARGET_CPU_SMP := true
PRODUCT_PACKAGE_OVERLAYS += device/rockchip/rk3288/overlay


# Disable emulator for "make dist" until there is a 64-bit qemu kernel
BUILD_EMULATOR := false
TARGET_BOARD_PLATFORM := rk3288
TARGET_BOARD_PLATFORM_GPU := mali-t760
BOARD_USE_DRM := true

# Sensors
BOARD_SENSOR_ST := false
BOARD_SENSOR_MPU := true
BOARD_USES_GENERIC_INVENSENSE := false


ifneq ($(filter %box, $(TARGET_PRODUCT)), )
TARGET_BOARD_PLATFORM_PRODUCT ?= box
else
 ifneq ($(filter %vr, $(TARGET_PRODUCT)), )
   TARGET_BOARD_PLATFORM_PRODUCT ?= vr
else
TARGET_BOARD_PLATFORM_PRODUCT ?= tablet
endif
endif

DEVICE_PACKAGE_OVERLAYS += device/rockchip/rk3288/overlay_screenoff

#######for target product ########
ifeq ($(strip $(TARGET_BOARD_PLATFORM_PRODUCT)), box)

PRODUCT_PROPERTY_OVERRIDES += \
        ro.target.product=box
else
  ifeq ($(strip $(TARGET_BOARD_PLATFORM_PRODUCT)), tablet)
  PRODUCT_PROPERTY_OVERRIDES += \
        ro.target.product=tablet
  else
     ro.target.product=vr
  endif
endif

ENABLE_CPUSETS := true
BOARD_SENSOR_MPU_PAD :=true
# Enable dex-preoptimization to speed up first boot sequence
ifeq ($(HOST_OS),linux)
    ifeq ($(TARGET_BUILD_VARIANT),user)
        WITH_DEXPREOPT := true
    else
        WITH_DEXPREOPT := false
    endif
endif

BOARD_NFC_SUPPORT := false
BOARD_HAS_GPS := false

BOARD_GRAVITY_SENSOR_SUPPORT := true
BOARD_COMPASS_SENSOR_SUPPORT := false
BOARD_GYROSCOPE_SENSOR_SUPPORT := true
BOARD_PROXIMITY_SENSOR_SUPPORT := false
BOARD_LIGHT_SENSOR_SUPPORT := false
BOARD_PRESSURE_SENSOR_SUPPORT := false
BOARD_TEMPERATURE_SENSOR_SUPPORT := false
BOARD_USB_HOST_SUPPORT := true

BOARD_USE_SPARSE_SYSTEM_IMAGE := true

#for verifyboot, set to true open verifyboot,PRODUCT_FLASH_TYPE should check too
PRODUCT_SYSTEM_VERITY := false
PRODUCT_FLASH_TYPE := EMMC

TARGET_COPY_OUT_VENDOR := vendor
#Calculate partition size from parameter.txt
USE_DEFAULT_PARAMETER := $(shell test -f $(TARGET_DEVICE_DIR)/parameter.txt && echo true)
ifeq ($(strip $(USE_DEFAULT_PARAMETER)), true)
  BOARD_VENDORIMAGE_PARTITION_SIZE := $(shell python device/rockchip/common/get_partition_size.py $(TARGET_DEVICE_DIR)/parameter.txt vendor0)
  #$(info Calculated BOARD_VENDORIMAGE_PARTITION_SIZE=$(BOARD_VENDORIMAGE_PARTITION_SIZE) use $(TARGET_DEVICE_DIR)/parameter.txt)
else
  BOARD_VENDORIMAGE_PARTITION_SIZE ?= 52428800
  ifneq ($(strip $(TARGET_DEVICE_DIR)),)
    #$(info $(TARGET_DEVICE_DIR)/parameter.txt not found! Use default BOARD_VENDORIMAGE_PARTITION_SIZE=$(BOARD_VENDORIMAGE_PARTITION_SIZE))
  endif
endif

BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Enable optee service
PRODUCT_HAVE_OPTEE := true
