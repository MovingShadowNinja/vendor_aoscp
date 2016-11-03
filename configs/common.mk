PRODUCT_BRAND ?= aoscp

SUPERUSER_EMBEDDED := true

# Include versioning information
# Format: Major.minor.maintenance(-TAG)
export AOSCP_VERSION := 3.1

export AOSCP_API := Cheesecake

AOSCP_DISPLAY_VERSION := $(AOSCP_VERSION)

export ROM_VERSION := $(AOSCP_VERSION)-$(shell date -u +%Y%m%d)

ifneq ($(RELEASE_TYPE),)
        AOSCP_BUILDTYPE := $(RELEASE_TYPE)
endif

ifeq ($(AOSCP_BUILDTYPE),)
        # AOSCP_BUILDTYPE is not defined
	AOSCP_BUILDTYPE := unofficial
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=$(ROM_VERSION) \
    ro.aoscp.version=$(AOSCP_VERSION) \
    ro.aoscp.device=$(AOSCP_DEVICE) \
    ro.aoscp.display.version=$(AOSCP_DISPLAY_VERSION) \
    ro.aoscp.releasetype=$(AOSCP_BUILDTYPE) \
    ro.aoscp.api=$(AOSCP_API)

AOSCP_ZIP_VERSION := $(AOSCP_VERSION)

ifeq ($(AOSCP_BUILDTYPE),unofficial)
	AOSCP_ZIP_VERSION := $(AOSCP_VERSION)-$(shell date -u +%Y%m%d)
else
ifeq ($(AOSCP_BUILDTYPE),nightly)
	AOSCP_ZIP_VERSION := $(AOSCP_VERSION)-$(shell date -u +%Y%m%d)
endif # nightly
endif

AOSCP_TARGET_ZIP=$(TARGET_PRODUCT)-$(AOSCP_ZIP_VERSION)

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ "$(TARGET_SCREEN_WIDTH)" -lt "$(TARGET_SCREEN_HEIGHT)" ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/aoscp/prebuilt/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ "$(1)" -le "$(TARGET_BOOTANIMATION_SIZE)" ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/aoscp/prebuilt/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/aoscp/prebuilt/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

# Common dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/aoscp/overlay/dictionaries
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
	ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent

#SELinux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Titania.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.alarm_alert=Argon.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

ifneq ($(TARGET_BUILD_VARIANT),userdebug)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=0
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/aoscp/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/aoscp/prebuilt/common/bin/50-aoscp.sh:system/addon.d/50-aoscp.sh \
    vendor/aoscp/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/aoscp/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/aoscp/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/aoscp/configs/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/etc/init.d/00start:system/etc/init.d/00start \
    vendor/aoscp/prebuilt/common/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
    vendor/aoscp/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/aoscp/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# AOSCP-specific init file
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/etc/init.local.rc:root/init.aoscp.rc \

# Installer
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/bin/persist.sh:install/bin/persist.sh \
    vendor/aoscp/prebuilt/common/etc/persist.conf:system/etc/persist.conf

PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/lib/libmicrobes_jni.so:system/lib/libmicrobes_jni.so \
    vendor/aoscp/prebuilt/common/etc/resolv.conf:system/etc/resolv.conf

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

PRODUCT_COPY_FILES += \
    vendor/aoscp/configs/permissions/com.aoscp.android.xml:system/etc/permissions/com.aoscp.android.xml

# Theme engine
include vendor/aoscp/configs/themes_common.mk

ifneq ($(TARGET_DISABLE_CMSDK), true)
# CMSDK
include vendor/aoscp/configs/cmsdk_common.mk
endif

# Required AOSCP packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    CellBroadcastReceiver \
    LatinIME \
    LatinImeDictionaryPack \
    Microbes \
    Stk

# Optional AOSCP packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal \
    LiveWallpapersPicker \
    PhotoTable

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# AOSCP Packages
PRODUCT_PACKAGES += \
	Browser \
    CMAudioService \
    CMFileManager \
    CMSettingsProvider \
    ExactCalculator \
    Luna \
	WallpaperPicker \
    SoundRecorder
	
# AOSCP Updates
ifneq ($(AOSCP_BUILDTYPE),unofficial)
PRODUCT_PACKAGES +=  \
   COTA
endif

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    tune2fs \
    nano \
    htop \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz \
    7z \
    lib7z \
    bash \
    bzip2 \
    curl \
    powertop \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=3

# Common overlay
DEVICE_PACKAGE_OVERLAYS += vendor/aoscp/overlay/common

# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/aoscp/configs/partner_gms.mk
-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
