DLKM_DIR := motorola/kernel/modules
LOCAL_PATH := $(call my-dir)

ifeq ($(DLKM_INSTALL_TO_VENDOR_OUT),true)
NOVA_MMI_MODULE_PATH := $(TARGET_OUT_VENDOR)/lib/modules/
else
NOVA_MMI_MODULE_PATH := $(KERNEL_MODULES_OUT)
endif

ifneq ($(BOARD_USES_DOUBLE_TAP),)
	KERNEL_CFLAGS += CONFIG_INPUT_NOVA_0FLASH_MMI_ENABLE_DOUBLE_TAP=y
endif

ifeq ($(TOUCHSCREEN_LAST_TIME),true)
	KERNEL_CFLAGS += CONFIG_NOVA_TOUCH_LAST_TIME=y
endif

ifneq ($(MOTO_PANEL_CHECK_TOUCH_STATE),)
	KBUILD_OPTIONS += CONFIG_INPUT_NOVA_0FLASH_MMI_NOTIFY_TOUCH_STATE=y
	LOCAL_ADDITIONAL_DEPENDENCIES += $(KERNEL_MODULES_OUT)/msm_drm.ko
endif

ifneq ($(BOARD_USES_PANEL_NOTIFICATIONS),)
	KERNEL_CFLAGS += CONFIG_INPUT_NOVA_PANEL_NOTIFICATIONS=y
endif

ifeq ($(CONFIG_INPUT_ENABLE_DRM_PANEL),true)
        KERNEL_CFLAGS += CONFIG_INPUT_NOVA_DRM_PANEL=y
endif

ifeq ($(CONFIG_INPUT_NOVA_USES_CHIP_VER_1),true)
	KERNEL_CFLAGS += CONFIG_INPUT_NOVA_CHIP_VER_1=y
endif

ifeq ($(CONFIG_INPUT_NOVA_ESD_ENABLE),true)
	KERNEL_CFLAGS += CONFIG_NOVA_ESD_ENABLE=y
endif

ifeq ($(CONFIG_INPUT_NOVA_LCM_FAST_LIGHTUP),true)
	KERNEL_CFLAGS += CONFIG_NOVA_LCM_FAST_LIGHTUP=y
endif

ifneq ($(BOARD_USES_PEN_NOTIFIER),)
	KBUILD_OPTIONS += CONFIG_INPUT_NOVA_0FLASH_MMI_PEN_NOTIFIER=y
endif

ifneq ($(BOARD_USES_STYLUS_PALM),)
	KBUILD_OPTIONS += CONFIG_INPUT_NOVA_0FLASH_MMI_STYLUS_PALM=y
endif

ifneq ($(BOARD_USES_STYLUS_PALM_RANGE),)
	KBUILD_OPTIONS += CONFIG_INPUT_NOVA_0FLASH_MMI_STYLUS_PALM_RANGE=y
endif
ifneq ($(BOARD_USES_EDGE_SUPPRESSION),)
	KERNEL_CFLAGS += CONFIG_INPUT_NOVA_EDGE_SUPPRESSION=y
endif
ifeq ($(DRM_PANEL_NOTIFICATIONS),true)
	KERNEL_CFLAGS += CONFIG_DRM_PANEL_NOTIFICATIONS=y
endif
ifeq ($(DRM_PANEL_EVENT_NOTIFICATIONS),true)
	KBUILD_OPTIONS += CONFIG_DRM_PANEL_EVENT_NOTIFICATIONS=y
endif
ifeq ($(TOUCH_PANEL_NOTIFICATIONS),true)
	KERNEL_CFLAGS += CONFIG_TOUCH_PANEL_NOTIFICATIONS=y
endif

ifeq ($(TOUCHCLASS_MMI_MULTIWAY_UPDATE_FW),true)
	KERNEL_CFLAGS += CONFIG_TOUCHCLASS_MMI_MULTIWAY_UPDATE_FW=y
endif

ifeq ($(BOARD_USES_DOUBLE_TAP_CTRL),true)
	KBUILD_OPTIONS += CONFIG_BOARD_USES_DOUBLE_TAP_CTRL=y
endif

include $(CLEAR_VARS)
ifneq ($(BOARD_USES_DOUBLE_TAP),)
LOCAL_ADDITIONAL_DEPENDENCIES += $(KERNEL_MODULES_OUT)/sensors_class.ko
endif
ifneq ($(BOARD_USES_PEN_NOTIFIER),)
LOCAL_ADDITIONAL_DEPENDENCIES += $(KERNEL_MODULES_OUT)/bu520xx_pen.ko
endif
LOCAL_MODULE := nova_0flash_mmi.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(KERNEL_MODULES_OUT)
LOCAL_ADDITIONAL_DEPENDENCIES += $(KERNEL_MODULES_OUT)/mmi_info.ko
ifneq ($(findstring touchscreen_mmi.ko,$(BOARD_VENDOR_KERNEL_MODULES)),)
	KBUILD_OPTIONS += CONFIG_INPUT_TOUCHSCREEN_MMI=y
	LOCAL_ADDITIONAL_DEPENDENCIES += $(KERNEL_MODULES_OUT)/touchscreen_mmi.ko
endif
ifneq ($(MOTO_PANEL_CHECK_TOUCH_STATE),)
	LOCAL_ADDITIONAL_DEPENDENCIES += $(KERNEL_MODULES_OUT)/msm_drm.ko
endif
KBUILD_OPTIONS_GKI += GKI_OBJ_MODULE_DIR=gki
KBUILD_OPTIONS_GKI += MODULE_KERNEL_VERSION=$(TARGET_KERNEL_VERSION)
include $(DLKM_DIR)/AndroidKernelModule.mk
