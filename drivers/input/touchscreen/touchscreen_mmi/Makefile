KBUILD_OPTIONS += CONFIG_DRM_PANEL_EVENT_NOTIFICATIONS=y
KBUILD_OPTIONS += CONFIG_BOARD_USES_DOUBLE_TAP_CTRL=y
KBUILD_OPTIONS += CONFIG_TOUCHSCREEN_DEVICE_VIRTUAL_PATH=y
KBUILD_OPTIONS += CONFIG_TOUCHSCREEN_EARLY_RESET_ON_RESUME=y

all: modules

modules:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(M) modules_install

%:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) $@ $(KBUILD_OPTIONS)

KBUILD_EXTRA_SYMBOLS += $(M)/../../../sensors/Module.symvers
KBUILD_EXTRA_SYMBOLS += $(M)/../../../mmi_relay/Module.symvers
ifneq ($(filter m y, $(CONFIG_DRM_DYNAMIC_REFRESH_RATE)),)
KBUILD_EXTRA_SYMBOLS += $(OUT_DIR)/../../vendor/qcom/opensource/display-drivers/msm/Module.symvers
endif
