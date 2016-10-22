# Permissions for cmsdk services
PRODUCT_COPY_FILES += \
    vendor/aoscp/configs/permissions/org.cyanogenmod.appsuggest.xml:system/etc/permissions/org.cyanogenmod.appsuggest.xml \
    vendor/aoscp/configs/permissions/org.cyanogenmod.audio.xml:system/etc/permissions/org.cyanogenmod.audio.xml \
    vendor/aoscp/configs/permissions/org.cyanogenmod.livedisplay.xml:system/etc/permissions/org.cyanogenmod.livedisplay.xml \
    vendor/aoscp/configs/permissions/org.cyanogenmod.partner.xml:system/etc/permissions/org.cyanogenmod.partner.xml \
    vendor/aoscp/configs/permissions/org.cyanogenmod.performance.xml:system/etc/permissions/org.cyanogenmod.performance.xml \
    vendor/aoscp/configs/permissions/org.cyanogenmod.telephony.xml:system/etc/permissions/org.cyanogenmod.telephony.xml \
    vendor/aoscp/configs/permissions/org.cyanogenmod.theme.xml:system/etc/permissions/org.cyanogenmod.theme.xml \

# CM Platform Library
PRODUCT_PACKAGES += \
    org.cyanogenmod.platform-res \
    org.cyanogenmod.platform \
    org.cyanogenmod.platform.xml

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# JNI Libraries
PRODUCT_PACKAGES += \
    libcmsdk_platform_jni