set_false_path -to [get_pins INTC_CORE_I/*intr_sync*/C]
set_false_path -from [get_pins INTC_CORE_I/*intr_sync*/C] -to [get_pins INTC_CORE_I/*intr_p1*/C]
### No false path constraints for paths crossing between AXI clock and processor clock domains
