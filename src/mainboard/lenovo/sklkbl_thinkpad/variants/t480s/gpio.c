/* SPDX-License-Identifier: GPL-2.0-only */

#include <soc/gpio.h>
#include "../../variant.h"

static const struct pad_config gpio_table[] = {
	/* ------- GPIO Community 0 ------- */

	/* ------- GPIO Group GPP_A ------- */
	PAD_CFG_NF(GPP_A0, NONE, DEEP, NF1),				/* -KBRC */
	PAD_CFG_NF(GPP_A1, NATIVE, DEEP, NF1),				/* LPC_AD0 */
	PAD_CFG_NF(GPP_A2, NATIVE, DEEP, NF1),				/* LPC_AD1 */
	PAD_CFG_NF(GPP_A3, NATIVE, DEEP, NF1),				/* LPC_AD2 */
	PAD_CFG_NF(GPP_A4, NATIVE, DEEP, NF1),				/* LPC_AD3 */
	PAD_CFG_NF(GPP_A5, NONE, DEEP, NF1),				/* -LPC_FRAME */
	PAD_CFG_NF(GPP_A6, NONE, DEEP, NF1),				/* IRQSER */
	PAD_CFG_NF(GPP_A7, NONE, DEEP, NF1),				/* -TPM_IRQ */
	PAD_CFG_NF(GPP_A8, NONE, DEEP, NF1),				/* -CLKRUN */
	PAD_CFG_NF(GPP_A9, DN_20K, DEEP, NF1),				/* LPCCLK_EC_24M */
	PAD_CFG_NF(GPP_A10, DN_20K, DEEP, NF1),				/* LPCCLK_DEBUG_24M */
	PAD_NC(GPP_A11, NONE),
	PAD_NC(GPP_A12, NONE),
	PAD_CFG_NF(GPP_A13, NONE, DEEP, NF1),				/* -SUSWARN */
	PAD_CFG_NF(GPP_A14, NONE, DEEP, NF1),				/* -SUS_STAT */
	PAD_CFG_NF(GPP_A15, UP_20K, DEEP, NF1),				/* -SUSWARN */
	PAD_NC(GPP_A16, NONE),
	PAD_NC(GPP_A17, NONE),
	PAD_NC(GPP_A18, NONE),
	PAD_NC(GPP_A19, NONE),
	PAD_NC(GPP_A20, NONE),
	PAD_NC(GPP_A21, NONE),
	PAD_NC(GPP_A22, NONE),
	PAD_NC(GPP_A23, NONE),

	/* ------- GPIO Group GPP_B ------- */
	PAD_CFG_NF(GPP_B0, NONE, DEEP, NF1),
	PAD_CFG_NF(GPP_B1, NONE, DEEP, NF1),
	PAD_NC(GPP_B2, NONE),
	PAD_NC(GPP_B3, NONE),
	PAD_CFG_GPI_SCI(GPP_B4, NONE, DEEP, EDGE_SINGLE, INVERT),	/* -TBT_PLUG_EVENT */
	PAD_CFG_NF(GPP_B5, NONE, DEEP, NF1),				/* -CLKREQ_PCIE0 (dGPU) */
	PAD_CFG_NF(GPP_B6, NONE, DEEP, NF1),				/* -CLKREQ_PCIE3 (WWAN) */
	PAD_CFG_NF(GPP_B7, NONE, DEEP, NF1),				/* -CLKREQ_PCIE4 (GBE) */
	PAD_CFG_NF(GPP_B8, NONE, DEEP, NF1),				/* -CLKREQ_PCIE5 (WLAN) */
	PAD_CFG_NF(GPP_B9, NONE, DEEP, NF1),				/* -CLKREQ_PCIE6 (TB3) */
	PAD_CFG_NF(GPP_B10, NONE, DEEP, NF1),				/* -CLKREQ_PCIE8 (SSD) */
	PAD_NC(GPP_B11, NONE),
	PAD_CFG_NF(GPP_B12, NONE, DEEP, NF1),				/* -PCH_SLP_S0 */
	PAD_CFG_NF(GPP_B13, NONE, DEEP, NF1),				/* -PLTRST */
	PAD_CFG_NF(GPP_B14, NONE, DEEP, NF1),				/* PCH_SPKR */
	PAD_CFG_GPO(GPP_B15, 0, DEEP),					/* NFC_DLREQ */
	PAD_NC(GPP_B16, NONE),
	PAD_NC(GPP_B17, NONE),
	PAD_NC(GPP_B18, NONE),
	PAD_NC(GPP_B19, NONE),
	PAD_NC(GPP_B20, NONE),
	PAD_NC(GPP_B21, NONE),
	PAD_NC(GPP_B22, NONE),
	PAD_NC(GPP_B23, NONE),

	/* ------- GPIO Community 1 ------- */

	/* ------- GPIO Group GPP_C ------- */
	PAD_CFG_NF(GPP_C0, NONE, DEEP, NF1),				/* SMB_CLK */
	PAD_CFG_NF(GPP_C1, NONE, DEEP, NF1),				/* SMB_DATA */
	PAD_CFG_GPO(GPP_C2, 1, DEEP),
	PAD_CFG_NF(GPP_C3, NONE, DEEP, NF1),				/* SML0_CLK */
	PAD_CFG_NF(GPP_C4, NONE, DEEP, NF1),				/* SML0_DATA */
	PAD_NC(GPP_C5, NONE),
	PAD_CFG_NF(GPP_C6, NONE, DEEP, NF1),				/* EC_SCL2 */
	PAD_CFG_NF(GPP_C7, NONE, DEEP, NF1),				/* EC_SDA2 */
	PAD_NC(GPP_C8, NONE),
	PAD_NC(GPP_C9, NONE),
	PAD_NC(GPP_C10, NONE),
	PAD_NC(GPP_C11, NONE),
	PAD_NC(GPP_C12, NONE),
	PAD_NC(GPP_C13, NONE),
	PAD_NC(GPP_C14, NONE),
	PAD_NC(GPP_C15, NONE),
	PAD_CFG_NF(GPP_C16, NONE, DEEP, NF1),				/* I2C0_DATA */
	PAD_CFG_NF(GPP_C17, NONE, DEEP, NF1),				/* I2C0_CLK */
	PAD_NC(GPP_C18, NONE),
	PAD_NC(GPP_C19, NONE),
	PAD_CFG_GPO(GPP_C20, 0, DEEP),					/* EPRIVACY_ON */
	PAD_CFG_GPO(GPP_C21, 0, DEEP),					/* TBT_FORCE_PWR */
	PAD_CFG_GPI_SCI(GPP_C22, NONE, DEEP, EDGE_SINGLE, INVERT),	/* -EC_SCI */
	PAD_CFG_GPI_SCI(GPP_C23, NONE, DEEP, EDGE_SINGLE, INVERT),	/* -EC_WAKE */

	/* ------- GPIO Group GPP_D ------- */
	PAD_NC(GPP_D0, NONE),
	PAD_NC(GPP_D1, NONE),
	PAD_NC(GPP_D2, NONE),
	PAD_NC(GPP_D3, NONE),
	PAD_NC(GPP_D4, NONE),
	PAD_NC(GPP_D5, NONE),
	PAD_NC(GPP_D6, NONE),
	PAD_NC(GPP_D7, NONE),
	PAD_NC(GPP_D8, NONE),
	PAD_CFG_GPI_TRIG_OWN(GPP_D9, UP_20K, DEEP, OFF, ACPI),		/* -DISCRETE_PRESENCE */
	PAD_NC(GPP_D10, NONE),
	PAD_CFG_GPI_TRIG_OWN(GPP_D11, UP_20K, DEEP, OFF, ACPI),		/* DGFX_VRAM_ID0 */
	PAD_CFG_GPI_TRIG_OWN(GPP_D12, UP_20K, DEEP, OFF, ACPI),		/* DGFX_VRAM_ID1 */
	PAD_NC(GPP_D13, NONE),
	PAD_NC(GPP_D14, NONE),
	PAD_NC(GPP_D15, NONE),
	PAD_NC(GPP_D16, NONE),
	PAD_CFG_GPO(GPP_D17, 0, DEEP),					/* DDI_PRIORITY */
	PAD_NC(GPP_D18, NONE),
	PAD_NC(GPP_D19, NONE),
	PAD_NC(GPP_D20, NONE),
	PAD_NC(GPP_D21, NONE),
	PAD_CFG_GPI_TRIG_OWN(GPP_D22, UP_20K, DEEP, OFF, ACPI),		/* -NFC_DTCT */
	PAD_NC(GPP_D23, NONE),

	/* ------- GPIO Group GPP_E ------- */
	PAD_CFG_GPO(GPP_E0, 1, DEEP),					/* BDC_ON */
	PAD_NC(GPP_E1, NONE),
	PAD_CFG_NF(GPP_E2, NONE, DEEP, NF1),				/* -SATA2_DTCT */
	PAD_CFG_GPI_TRIG_OWN(GPP_E3, NONE, DEEP, EDGE_SINGLE, ACPI),	/* -TBT_PLUG_EVENT */
	PAD_CFG_GPO(GPP_E4, 1, DEEP),					/* NFC_ON */
	PAD_NC(GPP_E5, NONE),
	PAD_CFG_NF(GPP_E6, NONE, RSMRST, NF1),				/* SATA2_DEVSLP */
	PAD_NC(GPP_E7, NONE),
	PAD_NC(GPP_E8, NONE),
	PAD_CFG_NF(GPP_E9, NONE, DEEP, NF1),				/* -USB_PORT0_OC0 */
	PAD_CFG_NF(GPP_E10, NONE, DEEP, NF1),				/* -USB_PORT1_OC1 */
	PAD_NC(GPP_E11, NONE),
	PAD_CFG_GPI_APIC_HIGH(GPP_E12, NONE, DEEP),			/* NFC_INT */
	PAD_CFG_NF(GPP_E13, NONE, DEEP, NF1),				/* DDIP1_HPD */
	PAD_CFG_NF(GPP_E14, NONE, DEEP, NF1),				/* DDIP2_HPD */
	PAD_NC(GPP_E15, NONE),
	PAD_NC(GPP_E16, NONE),
	PAD_CFG_NF(GPP_E17, NONE, DEEP, NF1),				/* EDP_HPD */
	PAD_NC(GPP_E18, NONE),
	PAD_CFG_GPO(GPP_E19, 0, DEEP),
	PAD_CFG_NF(GPP_E20, NONE, DEEP, NF1),				/* DDIP2_CTRLCLK */
	PAD_CFG_NF(GPP_E21, NONE, DEEP, NF1),				/* DDIP2_CTRLDATA */
	PAD_CFG_TERM_GPO(GPP_E22, 0, UP_20K, RSMRST),			/* -GPU_RST */
	PAD_CFG_TERM_GPO(GPP_E23, 0, UP_20K, RSMRST),			/* 1R8VIDEO_AON_ON */

	/* ------- GPIO Community 2 ------- */

	/* -------- GPIO Group GPD -------- */
	PAD_CFG_NF(GPD0, NONE, PWROK, NF1),				/* -BATLOW */
	PAD_CFG_NF(GPD1, NATIVE, PWROK, NF1),				/* AC_PRESENT */
	PAD_CFG_NF(GPD2, NATIVE, PWROK, NF1),				/* -LANWAKE */
	PAD_CFG_NF(GPD3, UP_20K, PWROK, NF1),				/* -PWRSW_EC */
	PAD_CFG_NF(GPD4, NONE, PWROK, NF1),				/* -PCH_SLP_S3 */
	PAD_CFG_NF(GPD5, NONE, PWROK, NF1),				/* -PCH_SLP_S4 */
	PAD_CFG_NF(GPD6, NONE, PWROK, NF1),				/* -PCH_SLP_M */
	PAD_NC(GPD7, NONE),
	PAD_CFG_NF(GPD8, NONE, PWROK, NF1),				/* SUSCLK_32K */
	PAD_CFG_NF(GPD9, NONE, PWROK, NF1),				/* -PCH_SLP_WLAN */
	PAD_CFG_NF(GPD10, NONE, PWROK, NF1),				/* -PCH_SLP_S5 */
	PAD_CFG_NF(GPD11, NONE, PWROK, NF1),				/* LANPHYPC */

	/* ------- GPIO Community 3 ------- */

	/* ------- GPIO Group GPP_F ------- */
	PAD_CFG_GPO(GPP_F0, 0, DEEP),
	PAD_CFG_GPI_TRIG_OWN(GPP_F1, NONE, DEEP, OFF, ACPI),		/* GC6_FB_EN */
	PAD_CFG_GPO(GPP_F2, 1, DEEP),					/* -GPU_EVENT */
	PAD_CFG_GPI_TRIG_OWN(GPP_F3, NONE, PLTRST, OFF, ACPI),		/* DGFX_PWRGD */
	PAD_NC(GPP_F4, NONE),						/* -WWAN_RESET */
	PAD_NC(GPP_F5, NONE),
	PAD_CFG_GPI_TRIG_OWN(GPP_F6, UP_20K, DEEP, OFF, ACPI),		/* -MIC_HW_EN (R37 to GND) */
	PAD_CFG_GPI_TRIG_OWN(GPP_F7, UP_20K, DEEP, OFF, ACPI),		/* -INT_MIC_DTCT */
	PAD_CFG_GPI_TRIG_OWN(GPP_F8, UP_20K, DEEP, OFF, ACPI),		/* WWAN_CFG0 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F9, UP_20K, DEEP, OFF, ACPI),		/* WWAN_CFG1 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F10, UP_20K, DEEP, OFF, ACPI),		/* WWAN_CFG2 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F11, UP_20K, DEEP, OFF, ACPI),		/* WWAN_CFG3 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F12, UP_20K, DEEP, OFF, ACPI),		/* PLANARID0 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F13, UP_20K, DEEP, OFF, ACPI),		/* PLANARID1 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F14, UP_20K, DEEP, OFF, ACPI),		/* PLANARID2 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F15, UP_20K, DEEP, OFF, ACPI),		/* PLANARID3 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F16, UP_20K, DEEP, OFF, ACPI),		/* MEMORYID0 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F17, UP_20K, DEEP, OFF, ACPI),		/* MEMORYID1 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F18, UP_20K, DEEP, OFF, ACPI),		/* MEMORYID2 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F19, UP_20K, DEEP, OFF, ACPI),		/* MEMORYID3 */
	PAD_CFG_GPI_TRIG_OWN(GPP_F20, UP_20K, DEEP, OFF, ACPI),		/* MEMORYID4 */
	PAD_NC(GPP_F21, NONE),
	PAD_CFG_GPI_TRIG_OWN(GPP_F22, UP_20K, DEEP, OFF, ACPI),		/* -TAMPER_SW_DTCT */
	PAD_CFG_GPI_TRIG_OWN(GPP_F23, UP_20K, DEEP, OFF, ACPI),		/* -SC_DTCT */

	/* ------- GPIO Group GPP_G ------- */
	PAD_NC(GPP_G0, NONE),
	PAD_NC(GPP_G1, NONE),
	PAD_NC(GPP_G2, NONE),
	PAD_NC(GPP_G3, NONE),
	PAD_CFG_GPO(GPP_G4, 0, DEEP),					/* TBT_RTD3_PWR_EN */
	PAD_CFG_GPO(GPP_G5, 0, DEEP),					/* TBT_FORCE_USB_PWR */
	PAD_CFG_GPO(GPP_G6, 0, DEEP),					/* -TBT_PERST */
	PAD_CFG_GPI_SCI(GPP_G7, NONE, DEEP, LEVEL, INVERT),		/* -TBT_PCIE_WAKE */
};

void variant_config_gpios(void)
{
	gpio_configure_pads(gpio_table, ARRAY_SIZE(gpio_table));
}
