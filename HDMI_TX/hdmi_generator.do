quit -sim
vcom hdmi_generator.vhd
vcom hdmi_generator_tb.vhd
vsim -c work.hdmi_generator_tb
# INPUTS
add wave -divider Inputs:
add wave -color yellow i_clk
add wave -color red i_reset_n
# OUTPUTS
add wave -divider Outputs:
add wave uut/o_hdmi_hs
# Internal
add wave -divider Internal:
add wave uut/o_x_counter

run -all