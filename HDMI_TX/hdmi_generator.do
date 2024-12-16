quit -sim
vcom hdmi_generator.vhd
#vcom hdmi_generator_fiack.vhd
vcom hdmi_generator_tb.vhd
vsim -c work.hdmi_generator_tb
# INPUTS
add wave -divider Inputs:
add wave -color yellow i_clk
add wave -color green i_reset_n
# OUTPUTS
add wave -divider Outputs:
add wave uut/o_hdmi_hs
add wave uut/o_hdmi_vs
add wave uut/o_hdmi_de

# Internal
add wave -divider Internal:

#add wave uut/s_h_count
#add wave uut/s_v_count
#add wave uut/s_h_act
#add wave uut/s_v_act

add wave uut/r_pixel_counter

run -all
