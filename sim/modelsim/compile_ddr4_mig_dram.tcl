################################################################################
# Compile Xilinx DDR4 DRAM Controller IP
# vsim -c -do compile_ddr4_mig_dram.do
################################################################################
if { [file exists mig7_dram] } {
 rm -rf mig7_dram
}

vlib mig7_dram

################################################################################
# Includes directories
################################################################################
set include_dir1 "+incdir+../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/map/ "
set include_dir2 "+incdir+../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/rtl/ip_top/ "
set include_dir3 "+incdir+../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/rtl/cal/ "
set include_dir4 "+incdir+../../backend/Xilinx/Vivado/ddr4_mig_dram/imports/ "
set include_dir5 "+incdir+/opt/Xilinx/Vivado/2020.1/data/xilinx_vip/include/ "

set include_dir $include_dir1$include_dir2$include_dir3$include_dir4$include_dir5

puts "################################################################################"
puts " Compilation of MicroBlaze                                                      "
puts "################################################################################"
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_0/sim/bd_8dc4_microblaze_I_0.vhd
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_1/sim/bd_8dc4_rst_0_0.vhd
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_2/sim/bd_8dc4_ilmb_0.vhd
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_3/sim/bd_8dc4_dlmb_0.vhd
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_4/sim/bd_8dc4_dlmb_cntlr_0.vhd
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_5/sim/bd_8dc4_ilmb_cntlr_0.vhd
vlog -64 -incr -work mig7_dram {*}$include_dir ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_6/sim/bd_8dc4_lmb_bram_I_0.v
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_7/sim/bd_8dc4_second_dlmb_cntlr_0.vhd
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_8/sim/bd_8dc4_second_ilmb_cntlr_0.vhd
vlog -64 -incr -work mig7_dram {*}$include_dir ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_9/sim/bd_8dc4_second_lmb_bram_I_0.v
vcom -64 -93   -work mig7_dram                 ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/ip/ip_10/sim/bd_8dc4_iomodule_0_0.vhd

#Top Of Microblaze_mcs
vlog -64 -incr -work mig7_dram {*}$include_dir ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/bd_0/sim/bd_8dc4.v
vlog -64 -incr -work mig7_dram {*}$include_dir ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_0/sim/ddr4_mig_dram_microblaze_mcs.v

puts "################################################################################"
puts " Compilation of Memory Controller                                               "
puts "################################################################################"
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/phy/ddr4_phy_v2_2_xiphy_behav.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/phy/ddr4_phy_v2_2_xiphy.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/iob/ddr4_phy_v2_2_iob_byte.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/iob/ddr4_phy_v2_2_iob.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/clocking/ddr4_phy_v2_2_pll.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_tristate_wrapper.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_riuor_wrapper.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_control_wrapper.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_byte_wrapper.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_bitslice_wrapper.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir +define+CALIB_SIM ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/phy/ddr4_mig_dram_phy_ddr4.sv 
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/ip_1/rtl/ip_top/ddr4_mig_dram_phy.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_wtr.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ref.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_rd_wr.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_periodic.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_group.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ecc_merge_enc.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ecc_gen.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ecc_fi_xor.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ecc_dec_fix.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ecc_buf.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ecc.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_ctl.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_cmd_mux_c.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_cmd_mux_ap.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_arb_p.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_arb_mux_p.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_arb_c.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_arb_a.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_act_timer.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc_act_rank.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/controller/ddr4_v2_2_mc.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/ui/ddr4_v2_2_ui_wr_data.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/ui/ddr4_v2_2_ui_rd_data.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/ui/ddr4_v2_2_ui_cmd.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/ui/ddr4_v2_2_ui.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_ar_channel.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_aw_channel.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_b_channel.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_cmd_arbiter.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_cmd_fsm.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_cmd_translator.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_fifo.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_incr_cmd.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_r_channel.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_w_channel.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_wr_cmd_fsm.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_wrap_cmd.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_a_upsizer.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_register_slice.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axi_upsizer.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_axic_register_slice.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_carry_and.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_carry_latch_and.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_carry_latch_or.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_carry_or.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_command_fifo.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_comparator.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_comparator_sel.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_comparator_sel_static.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_r_upsizer.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi/ddr4_v2_2_w_upsizer.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_addr_decode.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_read.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_reg_bank.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_reg.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_top.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_write.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/clocking/ddr4_v2_2_infrastructure.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_xsdb_bram.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_write.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_wr_byte.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_wr_bit.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_sync.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_read.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_rd_en.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_pi.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_mc_odt.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_debug_microblaze.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_cplx_data.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_cplx.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_config_rom.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir +define+CALIB_SIM ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_addr_decode.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_top.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal_xsdb_arbiter.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_cal.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_chipscope_xsdb_slave.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_v2_2_dp_AB9.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir +define+CALIB_SIM ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/cal/ddr4_mig_dram_ddr4_cal_riu.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/ip_top/ddr4_mig_dram.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir +define+CALIB_SIM ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/ip_top/ddr4_mig_dram_ddr4.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir                   ../../backend/Xilinx/Vivado/ddr4_mig_dram/ddr4_mig_dram.srcs/sources_1/ip/ddr4_mig_dram/rtl/ip_top/ddr4_mig_dram_ddr4_mem_intfc.sv

################################################################################
# Micron DDR4 DRAM Model
################################################################################
vlog -64 -incr -sv -work mig7_dram {*}$include_dir ../../backend/Xilinx/Vivado/ddr4_mig_dram/imports/arch_package.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir ../../backend/Xilinx/Vivado/ddr4_mig_dram/imports/proj_package.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir ../../backend/Xilinx/Vivado/ddr4_mig_dram/imports/ddr4_model.sv
vlog -64 -incr -sv -work mig7_dram {*}$include_dir ../../src/verilog/tb_ddr4_mig_dram/tb_ddr4_mig_dram.sv

################################################################################
# Xilinx GLBL
################################################################################
vlog -64 -incr     -work mig7_dram                 /opt/Xilinx/Vivado/2020.1/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/glbl.v

exit -f
