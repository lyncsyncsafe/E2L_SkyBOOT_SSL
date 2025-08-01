# SPDX-License-Identifier: BSD-3-Clause

# TODO: Move as much as possible to common

ifeq ($(CONFIG_SOC_AMD_PHOENIX_BASE),y)

subdirs-$(CONFIG_VBOOT_STARTS_BEFORE_BOOTBLOCK) += psp_verstage

# Beware that all-y also adds the compilation unit to verstage on PSP
all-y		+= aoac.c
all-y		+= config.c
all-y		+= i2c.c

# all_x86-y adds the compilation unit to all stages that run on the x86 cores
all_x86-y	+= gpio.c
all_x86-y	+= i3c.c
all_x86-y	+= uart.c

bootblock-y	+= early_fch.c
bootblock-y	+= espi_util.c

verstage-y	+= espi_util.c

romstage-$(CONFIG_SOC_AMD_PHOENIX_FSP) += fsp_m_params.c
romstage-y	+= soc_util.c

ramstage-y	+= acpi.c
ramstage-y	+= chip.c
ramstage-y	+= cpu.c
ramstage-y	+= fch.c
ramstage-$(CONFIG_SOC_AMD_PHOENIX_FSP) += fsp_s_params.c
ramstage-y	+= graphics.c
ramstage-y	+= mca.c
ramstage-y	+= memmap.c
ramstage-$(CONFIG_SOC_AMD_PHOENIX_OPENSIL) += pci_irq_routing.c
ramstage-y	+= root_complex.c
ramstage-y	+= soc_util.c
ramstage-y	+= xhci.c

smm-y		+= gpio.c
smm-y		+= root_complex.c
smm-y		+= smihandler.c
smm-$(CONFIG_DEBUG_SMI) += uart.c

CPPFLAGS_common += -I$(src)/soc/amd/phoenix/include
CPPFLAGS_common += -I$(src)/soc/amd/phoenix/acpi

ifeq ($(CONFIG_SOC_AMD_PHOENIX_FSP),y)
CPPFLAGS_common += -I$(src)/vendorcode/amd/fsp/phoenix
CPPFLAGS_common += -I$(src)/vendorcode/amd/fsp/common
endif

# Building the cbfs image will fail if the offset, aligned to 64 bytes, isn't large enough
ifeq ($(CONFIG_CBFS_VERIFICATION),y)
# 0x80 accounts for the cbfs_file struct + filename + metadata structs
AMD_FW_AB_POSITION := 0x80
else # ($(CONFIG_CBFS_VERIFICATION), y)
# 0x40 accounts for the cbfs_file struct + filename + metadata structs without hash attribute
AMD_FW_AB_POSITION := 0x40
endif # ($(CONFIG_CBFS_VERIFICATION), y)

PHOENIX_FW_A_POSITION=$(call int-add, \
	$(call get_fmap_value,FMAP_SECTION_FW_MAIN_A_START) $(AMD_FW_AB_POSITION))

PHOENIX_FW_B_POSITION=$(call int-add, \
	$(call get_fmap_value,FMAP_SECTION_FW_MAIN_B_START) $(AMD_FW_AB_POSITION))

#
# PSP Directory Table items
#
# Certain ordering requirements apply, however these are ensured by amdfwtool.
# For more information see "AMD Platform Security Processor BIOS Architecture
# Design Guide for AMD Family 17h Processors" (PID #55758, NDA only).
#

ifeq ($(CONFIG_PSP_DISABLE_POSTCODES),y)
PSP_SOFTFUSE_BITS += 7
endif

ifeq ($(CONFIG_PSP_UNLOCK_SECURE_DEBUG),y)
# Enable secure debug unlock
PSP_SOFTFUSE_BITS += 0
OPT_TOKEN_UNLOCK="--token-unlock"
endif

ifeq ($(CONFIG_PSP_LOAD_MP2_FW),y)
OPT_PSP_LOAD_MP2_FW="--load-mp2-fw"
else
# Disable MP2 firmware loading
PSP_SOFTFUSE_BITS += 29
endif

# Use additional Soft Fuse bits specified in Kconfig
PSP_SOFTFUSE_BITS += $(call strip_quotes, $(CONFIG_PSP_SOFTFUSE_BITS))

# type = 0x04
# The flashmap section used for this is expected to be named PSP_NVRAM
PSP_NVRAM_BASE=$(call get_fmap_value,FMAP_SECTION_PSP_NVRAM_START)
PSP_NVRAM_SIZE=$(call get_fmap_value,FMAP_SECTION_PSP_NVRAM_SIZE)

# type = 0x3a
ifeq ($(CONFIG_HAVE_PSP_WHITELIST_FILE),y)
PSP_WHITELIST_FILE=$(CONFIG_PSP_WHITELIST_FILE)
endif

# type = 0x54
# The flashmap section used for this is expected to be named PSP_RPMC_NVRAM
PSP_RPMC_NVRAM_BASE=$(call get_fmap_value,FMAP_SECTION_PSP_RPMC_NVRAM_START)
PSP_RPMC_NVRAM_SIZE=$(call get_fmap_value,FMAP_SECTION_PSP_RPMC_NVRAM_SIZE)

# type = 0x55
SPL_TABLE_FILE=$(CONFIG_SPL_TABLE_FILE)
ifeq ($(CONFIG_HAVE_SPL_RW_AB_FILE),y)
SPL_RW_AB_TABLE_FILE=$(CONFIG_SPL_RW_AB_TABLE_FILE)
else
SPL_RW_AB_TABLE_FILE=$(CONFIG_SPL_TABLE_FILE)
endif

#
# BIOS Directory Table items - proper ordering is managed by amdfwtool
#

# type = 0x60
PSP_APCB_FILES=$(APCB_SOURCES) $(APCB_SOURCES_RECOVERY)

# type = 0x61
PSP_APOB_BASE=$(CONFIG_PSP_APOB_DRAM_ADDRESS)

# type = 0x62
PSP_BIOSBIN_FILE=$(obj)/amd_biospsp.img
PSP_ELF_FILE=$(objcbfs)/bootblock_fixed_data.elf
PSP_BIOSBIN_SIZE=$(shell $(READELF_bootblock) -Wl $(PSP_ELF_FILE) | grep LOAD | awk '{print $$5}')
PSP_BIOSBIN_DEST=$(shell $(READELF_bootblock) -Wl $(PSP_ELF_FILE) | grep LOAD | awk '{print $$3}')

ifneq ($(CONFIG_SOC_AMD_COMMON_BLOCK_APOB_NV_DISABLE),y)
# type = 0x63 - construct APOB NV base/size from flash map
# The flashmap section used for this is expected to be named RW_MRC_CACHE
APOB_NV_SIZE=$(call get_fmap_value,FMAP_SECTION_RW_MRC_CACHE_SIZE)
APOB_NV_BASE=$(call get_fmap_value,FMAP_SECTION_RW_MRC_CACHE_START)

ifeq ($(CONFIG_HAS_RECOVERY_MRC_CACHE)$(CONFIG_VBOOT),yy)
# On boards with recovery MRC cache, point type 0x63 entry to RECOVERY_MRC_CACHE.
# Else use RW_MRC_CACHE. This entry will be added in the RO section.
APOB_NV_RO_SIZE=$(call get_fmap_value,FMAP_SECTION_RECOVERY_MRC_CACHE_SIZE)
APOB_NV_RO_BASE=$(call get_fmap_value,FMAP_SECTION_RECOVERY_MRC_CACHE_START)
else
APOB_NV_RO_SIZE=$(APOB_NV_SIZE)
APOB_NV_RO_BASE=$(APOB_NV_BASE)
endif
endif # !CONFIG_SOC_AMD_COMMON_BLOCK_APOB_NV_DISABLE

ifeq ($(CONFIG_AMDFW_SPLIT),y)
FMAP_AMDFW_BODY_LOCATION=$(call get_fmap_value,FMAP_SECTION_AMDFWBODY_START)
endif

ifeq ($(CONFIG_VBOOT_STARTS_BEFORE_BOOTBLOCK),y)
# type = 0x6B - PSP Shared memory location
ifneq ($(CONFIG_PSP_SHAREDMEM_SIZE),0x0)
PSP_SHAREDMEM_SIZE=$(CONFIG_PSP_SHAREDMEM_SIZE)
PSP_SHAREDMEM_BASE=$(shell awk '$$3 == "_psp_sharedmem_dram" {printf "0x" $$1}' $(objcbfs)/bootblock.map)
endif

# type = 0x52 - PSP Bootloader Userspace Application (verstage)
PSP_VERSTAGE_FILE=$(call strip_quotes,$(CONFIG_PSP_VERSTAGE_FILE))
PSP_VERSTAGE_SIG_FILE=$(call strip_quotes,$(CONFIG_PSP_VERSTAGE_SIGNING_TOKEN))
endif # CONFIG_VBOOT_STARTS_BEFORE_BOOTBLOCK

ifeq ($(CONFIG_SEPARATE_SIGNED_PSPFW),y)
SIGNED_AMDFW_A_POSITION=$(call get_fmap_value,FMAP_SECTION_SIGNED_AMDFW_A_START)
SIGNED_AMDFW_B_POSITION=$(call get_fmap_value,FMAP_SECTION_SIGNED_AMDFW_B_START)
SIGNED_AMDFW_A_FILE=$(obj)/amdfw_a.rom.signed
SIGNED_AMDFW_B_FILE=$(obj)/amdfw_b.rom.signed
endif # CONFIG_SEPARATE_SIGNED_PSPFW

# Helper function to return a value with given bit set
# Soft Fuse type = 0xb - See #55758 (NDA) for bit definitions.
set-bit=$(call int-shift-left, 1 $(call _toint,$1))
PSP_SOFTFUSE=$(shell A=$(call int-add, \
		$(foreach bit,$(sort $(PSP_SOFTFUSE_BITS)),$(call set-bit,$(bit)))); printf "0x%x" $$A)

#
# Build the arguments to amdfwtool (order is unimportant).  Missing file names
# result in empty OPT_ variables, i.e. the argument is not passed to amdfwtool.
#

add_opt_prefix=$(if $(call strip_quotes, $(1)), $(2) $(call strip_quotes, $(1)), )

OPT_PSP_NVRAM_BASE=$(call add_opt_prefix, $(PSP_NVRAM_BASE), --nvram-base)
OPT_PSP_NVRAM_SIZE=$(call add_opt_prefix, $(PSP_NVRAM_SIZE), --nvram-size)

OPT_PSP_RPMC_NVRAM_BASE=$(call add_opt_prefix, $(PSP_RPMC_NVRAM_BASE), --rpmc-nvram-base)
OPT_PSP_RPMC_NVRAM_SIZE=$(call add_opt_prefix, $(PSP_RPMC_NVRAM_SIZE), --rpmc-nvram-size)

OPT_VERSTAGE_FILE=$(call add_opt_prefix, $(PSP_VERSTAGE_FILE), --verstage)
OPT_VERSTAGE_SIG_FILE=$(call add_opt_prefix, $(PSP_VERSTAGE_SIG_FILE), --verstage_sig)

OPT_PSP_APCB_FILES= $(if $(APCB_SOURCES), --instance 0 --apcb $(APCB_SOURCES)) \
                    $(if $(APCB_SOURCES_RECOVERY), --instance 10 --apcb $(APCB_SOURCES_RECOVERY)) \
                    $(if $(APCB_SOURCES_68), --instance 18 --apcb $(APCB_SOURCES_68))

OPT_APOB_ADDR=$(call add_opt_prefix, $(PSP_APOB_BASE), --apob-base)
OPT_PSP_BIOSBIN_FILE=$(call add_opt_prefix, $(PSP_BIOSBIN_FILE), --bios-bin)
OPT_PSP_BIOSBIN_DEST=$(call add_opt_prefix, $(PSP_BIOSBIN_DEST), --bios-bin-dest)
OPT_PSP_BIOSBIN_SIZE=$(call add_opt_prefix, $(PSP_BIOSBIN_SIZE), --bios-uncomp-size)

OPT_PSP_SHAREDMEM_BASE=$(call add_opt_prefix, $(PSP_SHAREDMEM_BASE), --sharedmem)
OPT_PSP_SHAREDMEM_SIZE=$(call add_opt_prefix, $(PSP_SHAREDMEM_SIZE), --sharedmem-size)
OPT_APOB_NV_SIZE=$(call add_opt_prefix, $(APOB_NV_SIZE), --apob-nv-size)
OPT_APOB_NV_BASE=$(call add_opt_prefix, $(APOB_NV_BASE),--apob-nv-base)
OPT_APOB_NV_RO_SIZE=$(call add_opt_prefix, $(APOB_NV_RO_SIZE), --apob-nv-size)
OPT_APOB_NV_RO_BASE=$(call add_opt_prefix, $(APOB_NV_RO_BASE),--apob-nv-base)
OPT_EFS_SPI_READ_MODE=$(call add_opt_prefix, $(CONFIG_EFS_SPI_READ_MODE), --spi-read-mode)
OPT_EFS_SPI_SPEED=$(call add_opt_prefix, $(CONFIG_EFS_SPI_SPEED), --spi-speed)
OPT_EFS_SPI_MICRON_FLAG=$(call add_opt_prefix, $(CONFIG_EFS_SPI_MICRON_FLAG), --spi-micron-flag)

OPT_SIGNED_AMDFW_A_POSITION=$(call add_opt_prefix, $(SIGNED_AMDFW_A_POSITION), --signed-addr)
OPT_SIGNED_AMDFW_A_FILE=$(call add_opt_prefix, $(SIGNED_AMDFW_A_FILE), --signed-output)
OPT_SIGNED_AMDFW_B_POSITION=$(call add_opt_prefix, $(SIGNED_AMDFW_B_POSITION), --signed-addr)
OPT_SIGNED_AMDFW_B_FILE=$(call add_opt_prefix, $(SIGNED_AMDFW_B_FILE), --signed-output)

OPT_PSP_SOFTFUSE=$(call add_opt_prefix, $(PSP_SOFTFUSE), --soft-fuse)

OPT_WHITELIST_FILE=$(call add_opt_prefix, $(PSP_WHITELIST_FILE), --whitelist)
OPT_SPL_TABLE_FILE=$(call add_opt_prefix, $(SPL_TABLE_FILE), --spl-table)
OPT_SPL_RW_AB_TABLE_FILE=$(call add_opt_prefix, $(SPL_RW_AB_TABLE_FILE), --spl-table)

# If vboot uses 2 RW slots, then 2 copies of PSP binaries are redundant
OPT_RECOVERY_AB_SINGLE_COPY=$(if $(CONFIG_VBOOT_SLOTS_RW_AB), --recovery-ab-single-copy)

OPT_AMDFW_BODY_LOCATION=$(call add_opt_prefix, $(FMAP_AMDFW_BODY_LOCATION), --body-location)

MANIFEST_FILE=$(obj)/amdfw_manifest
OPT_MANIFEST=$(call add_opt_prefix, $(MANIFEST_FILE), --output-manifest)

AMDFW_COMMON_ARGS=$(OPT_PSP_APCB_FILES) \
		$(OPT_PSP_NVRAM_BASE) \
		$(OPT_PSP_NVRAM_SIZE) \
		$(OPT_PSP_RPMC_NVRAM_BASE) \
		$(OPT_PSP_RPMC_NVRAM_SIZE) \
		$(OPT_APOB_ADDR) \
		$(OPT_DEBUG_AMDFWTOOL) \
		$(OPT_PSP_BIOSBIN_FILE) \
		$(OPT_PSP_BIOSBIN_DEST) \
		$(OPT_PSP_BIOSBIN_SIZE) \
		$(OPT_PSP_SOFTFUSE) \
		$(OPT_PSP_LOAD_MP2_FW) \
		--use-pspsecureos \
		--load-s0i3 \
		$(OPT_TOKEN_UNLOCK) \
		$(OPT_WHITELIST_FILE) \
		$(OPT_PSP_SHAREDMEM_BASE) \
		$(OPT_PSP_SHAREDMEM_SIZE) \
		$(OPT_EFS_SPI_READ_MODE) \
		$(OPT_EFS_SPI_SPEED) \
		$(OPT_EFS_SPI_MICRON_FLAG) \
		--config $(CONFIG_AMDFW_CONFIG_FILE) \
		--flashsize $(CONFIG_ROM_SIZE) \
		$(OPT_RECOVERY_AB_SINGLE_COPY) \
		$(OPT_AMDFW_BODY_LOCATION)

$(obj)/amdfw.rom:	$(call strip_quotes, $(PSP_BIOSBIN_FILE)) \
			$(PSP_VERSTAGE_FILE) \
			$(PSP_VERSTAGE_SIG_FILE) \
			$$(PSP_APCB_FILES) \
			$(DEP_FILES) \
			$(AMDFWTOOL) \
			$(obj)/fmap_config.h \
			$(objcbfs)/bootblock_fixed_data.elf # this target also creates the .map file
	rm -f $@
	@printf "    AMDFWTOOL  $(subst $(obj)/,,$(@))\n"
	$(AMDFWTOOL) \
		$(AMDFW_COMMON_ARGS) \
		$(OPT_APOB_NV_RO_SIZE) \
		$(OPT_APOB_NV_RO_BASE) \
		$(OPT_VERSTAGE_FILE) \
		$(OPT_VERSTAGE_SIG_FILE) \
		$(OPT_SPL_TABLE_FILE) \
		$(OPT_MANIFEST) \
		--location $(CONFIG_AMD_FWM_POSITION) \
		--output $@

ifeq ($(CONFIG_AMDFW_SPLIT),y)
$(obj)/amdfw.rom.body: $(obj)/amdfw.rom
$(call add_intermediate, add_amdfwbody, $(obj)/amdfw.rom.body)
	$(CBFSTOOL) $(obj)/coreboot.pre write -r AMDFWBODY -f $(obj)/amdfw.rom.body --fill-upward
endif

#
# Extracts everything from the ELF's first PT_LOAD area and compresses it.
# This discards everything before PT_LOAD, every symbol, debug information
# and relocations. The generated binary is expected to run at PSP_BIOSBIN_DEST
# with a maximum size of PSP_BIOSBIN_SIZE. The entrypoint is fixed at
# PSP_BIOSBIN_DEST + PSP_BIOSBIN_SIZE - 0x10.
#
$(PSP_BIOSBIN_FILE): $(PSP_ELF_FILE) $(AMDCOMPRESS)
	rm -f $@
	@printf "    AMDCOMPRS  $(subst $(obj)/,,$(@))\n"
	$(AMDCOMPRESS) --infile $(PSP_ELF_FILE) --outfile $@ --compress \
		--maxsize $(PSP_BIOSBIN_SIZE)

$(obj)/amdfw_a.rom: $(obj)/amdfw.rom
	rm -f $@
	@printf "    AMDFWTOOL  $(subst $(obj)/,,$(@))\n"
	$(AMDFWTOOL) \
		$(AMDFW_COMMON_ARGS) \
		$(OPT_APOB_NV_SIZE) \
		$(OPT_APOB_NV_BASE) \
		$(OPT_SPL_RW_AB_TABLE_FILE) \
		$(OPT_SIGNED_AMDFW_A_POSITION) \
		$(OPT_SIGNED_AMDFW_A_FILE) \
		--location $(call _tohex,$(PHOENIX_FW_A_POSITION)) \
		--anywhere \
		--output $@

$(obj)/amdfw_b.rom: $(obj)/amdfw.rom
	rm -f $@
	@printf "    AMDFWTOOL  $(subst $(obj)/,,$(@))\n"
	$(AMDFWTOOL) \
		$(AMDFW_COMMON_ARGS) \
		$(OPT_APOB_NV_SIZE) \
		$(OPT_APOB_NV_BASE) \
		$(OPT_SPL_RW_AB_TABLE_FILE) \
		$(OPT_SIGNED_AMDFW_B_POSITION) \
		$(OPT_SIGNED_AMDFW_B_FILE) \
		--location $(call _tohex,$(PHOENIX_FW_B_POSITION)) \
		--anywhere \
		--output $@


$(MANIFEST_FILE): $(obj)/amdfw.rom
cbfs-files-y += amdfw_manifest
amdfw_manifest-file := $(MANIFEST_FILE)
amdfw_manifest-type := raw

ifeq ($(CONFIG_VBOOT_SLOTS_RW_AB)$(CONFIG_VBOOT_STARTS_BEFORE_BOOTBLOCK),yy)
cbfs-files-y += apu/amdfw_a
apu/amdfw_a-file := $(obj)/amdfw_a.rom
apu/amdfw_a-position := $(AMD_FW_AB_POSITION)
apu/amdfw_a-type := raw

cbfs-files-y += apu/amdfw_b
apu/amdfw_b-file := $(obj)/amdfw_b.rom
apu/amdfw_b-position := $(AMD_FW_AB_POSITION)
apu/amdfw_b-type := raw

ifeq ($(CONFIG_SEPARATE_SIGNED_PSPFW),y)
build_complete:: $(obj)/amdfw_a.rom $(obj)/amdfw_b.rom
	@printf "    Adding Signed ROM and HASH\n"
	$(CBFSTOOL) $(obj)/coreboot.rom write -u -r SIGNED_AMDFW_A -i 0 -f $(obj)/amdfw_a.rom.signed
	$(CBFSTOOL) $(obj)/coreboot.rom write -u -r SIGNED_AMDFW_B -i 0 -f $(obj)/amdfw_b.rom.signed
	$(CBFSTOOL) $(obj)/coreboot.rom add -r FW_MAIN_A -f $(obj)/amdfw_a.rom.signed.hash \
		-n apu/amdfw_a_hash -t raw
	$(CBFSTOOL) $(obj)/coreboot.rom add -r FW_MAIN_B -f $(obj)/amdfw_b.rom.signed.hash \
		-n apu/amdfw_b_hash -t raw
	if [ -n "$(wildcard $(obj)/amdfw_a.rom.signed.1.hash)" ]; then \
		$(CBFSTOOL) $(obj)/coreboot.rom add -r FW_MAIN_A -f \
			$(obj)/amdfw_a.rom.signed.1.hash -n apu/amdfw_a_hash1 -t raw; \
		$(CBFSTOOL) $(obj)/coreboot.rom add -r FW_MAIN_B -f \
			$(obj)/amdfw_b.rom.signed.1.hash -n apu/amdfw_b_hash1 -t raw; \
	fi
	if [ -n "$(wildcard $(obj)/amdfw_a.rom.signed.2.hash)" ]; then \
		$(CBFSTOOL) $(obj)/coreboot.rom add -r FW_MAIN_A -f \
			$(obj)/amdfw_a.rom.signed.2.hash -n apu/amdfw_a_hash2 -t raw; \
		$(CBFSTOOL) $(obj)/coreboot.rom add -r FW_MAIN_B -f \
			$(obj)/amdfw_b.rom.signed.2.hash -n apu/amdfw_b_hash2 -t raw; \
	fi
endif # CONFIG_SEPARATE_SIGNED_PSPFW
endif

# Add ranges for all components up until the first segment of BIOS to be verified by GSC
ifeq ($(CONFIG_VBOOT_GSCVD),y)
# Adding range for Bootblock
vboot-gscvd-ranges += $(call amdfwread-range-cmd,BIOSL2: 0x62)
# Adding range for PSP Stage1 Bootloader
vboot-gscvd-ranges += $(call amdfwread-range-cmd,PSPL2: 0x01)

ifeq ($(CONFIG_VBOOT_STARTS_BEFORE_BOOTBLOCK),y)
# Adding range for PSP Verstage
vboot-gscvd-ranges += $(call amdfwread-range-cmd,PSPL2: 0x52)
endif # ifeq ($(CONFIG_VBOOT_STARTS_BEFORE_BOOTBLOCK),y)
endif # ifeq ($(CONFIG_VBOOT_GSCVD),y)

endif # ($(CONFIG_SOC_AMD_PHOENIX_BASE),y)
