/* SPDX-License-Identifier: GPL-2.0-only */

#include <baseboard/gpio.h>
#include <baseboard/variants.h>
#include <soc/gpio.h>

static const struct pad_config early_uart_gpio_table[] = {
	/* UART0 RX */
	PAD_CFG_NF(GPP_H10, NONE, DEEP, NF2),
	/* UART0 TX */
	PAD_CFG_NF(GPP_H11, NONE, DEEP, NF2),
	/* UART1 RX */
	PAD_CFG_NF(GPP_D17, NONE, DEEP, NF1),
	/* UART1 TX */
	PAD_CFG_NF(GPP_D18, NONE, DEEP, NF1),
	/* UART2 RX */
	PAD_CFG_NF(GPP_F1, NONE, DEEP, NF2),
	/* UART2 TX */
	PAD_CFG_NF(GPP_F2, NONE, DEEP, NF2),
};

void variant_configure_early_gpio_pads(void)
{
	if (CONFIG(INTEL_LPSS_UART_FOR_CONSOLE))
		gpio_configure_pads(early_uart_gpio_table, ARRAY_SIZE(early_uart_gpio_table));

}
