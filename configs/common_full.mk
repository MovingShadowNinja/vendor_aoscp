# Inherit common AOSCP stuff
$(call inherit-product, vendor/aoscp/configs/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

PRODUCT_SIZE := full

# Include AOSCP LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/aoscp/overlay/dictionaries

PRODUCT_PACKAGES += \
    VideoEditor \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer

# Themes
PRODUCT_PACKAGES += \
    HexoLibre
