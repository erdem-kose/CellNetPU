set ethernet_input {Ethernet_Lite_RXD* Ethernet_Lite_RX_DV Ethernet_Lite_COL Ethernet_Lite_RX_ER}
set ethernet_output {Ethernet_Lite_TXD* Ethernet_Lite_TX_EN}
set_input_delay -max 34 -clock PHY_rx_clk $ethernet_input
set_output_delay -max 10 -clock PHY_tx_clk $ethernet_output
set clk_domain_a [get_clocks -of_objects [get_ports PHY_tx_clk]]
set clk_domain_b [get_clocks -of_objects [get_ports PHY_rx_clk]]
set clk_domain_c [get_clocks -of_objects [get_ports S_AXI_ACLK]]
set_false_path -from [all_registers -clock $clk_domain_a] -to [all_registers -clock $clk_domain_b]
set_false_path -from [all_registers -clock $clk_domain_b] -to [all_registers -clock $clk_domain_a]
set_false_path -from [all_registers -clock $clk_domain_b] -to [all_registers -clock $clk_domain_c]
set_false_path -from [all_registers -clock $clk_domain_c] -to [all_registers -clock $clk_domain_b]
set_false_path -from [all_registers -clock $clk_domain_c] -to [all_registers -clock $clk_domain_a]
set_false_path -from [all_registers -clock $clk_domain_a] -to [all_registers -clock $clk_domain_c]
set_false_path -through [get_ports PHY_tx_clk] -to [all_registers -clock $clk_domain_c]
