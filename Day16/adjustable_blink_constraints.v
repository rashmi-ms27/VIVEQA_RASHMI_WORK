# LED Output
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports led]

# Clock (24 MHz)
create_clock -period 41.667 -name sys_clk [get_ports clk]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports clk]

# Increase Speed Button
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports btn_inc]

# Decrease Speed Button
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports btn_dec]