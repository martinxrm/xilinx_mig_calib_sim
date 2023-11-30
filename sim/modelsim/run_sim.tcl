
#Set ACCURATE_SIM to 1 to get the accurate timings (will slow down simulation)
set ACCURATE_SIM 0

#Verilog Optimization
if { $ACCURATE_SIM == "1" } {
  vopt -64 \
       +acc=npr \
       -assertdebug \
       -L microblaze_v10_0_7 \
       -L lib_cdc_v1_0_2 \
       -L proc_sys_reset_v5_0_13 \
       -L lmb_v10_v3_0_11 \
       -L lmb_bram_if_cntlr_v4_0_14 \
       -L blk_mem_gen_v8_4_1 \
       -L iomodule_v3_1_3 \
       -L unisims_ver mig7_dram.glbl \
       -L unimacro_ver \
       -L secureip \
       -L xpm \
       -L mig7_dram \
       -work mig7_dram tb_ddr4_mig_dram -o tb_ddr4_mig_dram_opt
} else {
  vopt -64 \
       +acc=npr \
       -assertdebug \
       -L microblaze_v10_0_7 \
       -L lib_cdc_v1_0_2 \
       -L proc_sys_reset_v5_0_13 \
       -L lmb_v10_v3_0_11 \
       -L lmb_bram_if_cntlr_v4_0_18 \
       -L blk_mem_gen_v8_4_4 \
       -L iomodule_v3_1_6 \
       -L unisims_ver mig7_dram.glbl \
       -L unimacro_ver \
       -L secureip \
       -L xpm \
       -L mig7_dram \
       -G t200us=100 \
       -G t500us=150 \
       -work mig7_dram tb_ddr4_mig_dram -o tb_ddr4_mig_dram_opt
}

vsim -64 \
     -lib mig7_dram tb_ddr4_mig_dram_opt 

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

add wave sim:/tb_ddr4_mig_dram/*
run -al

