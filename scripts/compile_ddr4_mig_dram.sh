#! /bin/bash
vivado_project_name=ddr4_mig_dram
vivado_project_path=$(pwd)/backend/Xilinx/Vivado/$vivado_project_name
vivado_mig_ip_name=ddr4_mig_dram
vivado_mig_ip_path=$vivado_project_path/$vivado_project_name.srcs/sources_1/ip/$vivado_mig_ip_name
vivado_tcl_file=$(pwd)/tmp_vivado_mig_gen.tcl

vivado_version=2020.1
vivado_path=/opt/Xilinx/Vivado/$vivado_version/
vivado_exec=$vivado_path/bin/vivado
updatemem_exec=/opt/Xilinx/Vitis/$vivado_version/bin/updatemem

questa_scripts=$(pwd)/sim/modelsim/
questa_version=2020.1
questa_exec=/opt/Mentor/Questa$questa_version/questasim/linux_x86_64
vsim_exec=$questa_exec/vsim

echo '##################################################################################'
echo 'XILINX DDR4 DRAM MIG Generation and compilation with Vivado '$vivado_version' and QuestaSim '$questa_version
echo '##################################################################################'


################################################################################
#Clean Up
################################################################################
rm -rf $vivado_project_path

################################################################################
# VIVADO TCL generation script
################################################################################
#VIVADO project creation
echo 'create_project             \' >  $vivado_tcl_file
echo '  '$vivado_project_name'   \' >> $vivado_tcl_file
echo '  '$vivado_project_path'   \' >> $vivado_tcl_file
echo '  -part xcvu9p-flgb2104-2-i ' >> $vivado_tcl_file

# DRAM IP Creation
echo 'create_ip                         \' >> $vivado_tcl_file
echo '  -name ddr4                      \' >> $vivado_tcl_file
echo '  -vendor xilinx.com              \' >> $vivado_tcl_file
echo '  -library ip                     \' >> $vivado_tcl_file
echo '  -version 2.2                    \' >> $vivado_tcl_file
echo '  -module_name '$vivado_mig_ip_name  >> $vivado_tcl_file


echo 'set_property                                          \' >> $vivado_tcl_file
echo '  -dict [list                                         \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_AxiSelection     {true}            \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_TimePeriod       {833}             \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_InputClockPeriod {2999}            \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_CLKOUT0_DIVIDE   {5}               \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_Ordering         {Strict}          \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_Mem_Add_Map      {BANK_ROW_COLUMN} \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_CasWriteLatency  {12}              \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_CasLatency       {18}              \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_AxiAddressWidth  {30}              \' >> $vivado_tcl_file
echo '    CONFIG.C0.DDR4_MemoryPart       {MT40A1G8PM-075E} \' >> $vivado_tcl_file
echo '  ] [get_ips ddr4_mig_dram]                            ' >> $vivado_tcl_file

#Generation of RTL Files
echo 'generate_target all [get_files ' $vivado_mig_ip_path'/'$vivado_mig_ip_name'.xci]' >> $vivado_tcl_file

#exit from vivado
echo 'exit' >> $vivado_tcl_file

################################################################################
# Launch Vivado and source TCL File
################################################################################
echo ' VIVADO Launch'
$vivado_exec -mode tcl -source $vivado_tcl_file

#Clean Up
rm $vivado_tcl_file
rm vivado.jou
rm vivado.log

################################################################################
# Import DDR Model Files
# * arch_defines.v      : MICRON - Defines chip sizes and widths.
# * arch_package.sv     : MICRON - Defines parameters, enums and structures for DDR4.
# * ddr4_model.svp      : MICRON - Defines ideal DDR4 dram behavior.
# * interface.sv        : MICRON - Defines 'interface iDDR4'.
# * MemoryArray.svp     : MICRON - Defines 'class MemoryArray'.
# * proj_package.sv     : MICRON - Defines parameters, enums and structures for this specific DDR4.
# * StateTableCore.svp  : MICRON - Dram state core functionality.
# * StateTable.svp      : MICRON - Wrapper around StateTableCore which creates 'module StateTable'.
# * timing_tasks.sv     : MICRON - Defines enums and timing parameters for available speed grades.
################################################################################
mkdir -p $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/arch_defines.v    $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/arch_package.sv   $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/ddr4_model.sv     $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/interface.sv      $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/MemoryArray.sv    $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/proj_package.sv   $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/StateTableCore.sv $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/StateTable.sv     $vivado_project_path/imports/
cp $vivado_path/data/ip/xilinx/ddr4_v2_2/data/dlib/ultrascale/ddr4_sdram/tb/ddr4_model/timing_tasks.sv   $vivado_project_path/imports/



#Generate DDR4 memory Wrapper - XILINX
memory_wrapper_file=$vivado_project_path/imports/ddr4_sdram_model_wrapper.sv
echo '`define DDR4_8G_X8        ' >   $memory_wrapper_file
echo '`define DDR4_833_Timing   ' >>  $memory_wrapper_file
echo '`define SILENT            ' >>  $memory_wrapper_file
echo '`define FIXED_2400        ' >>  $memory_wrapper_file

################################################################################
# Generate Microblaze initialization of value
################################################################################
echo 'Generation of Mem Init Files for Microblaze'

#generate SMI File for Microblaze_mcs.
# This File can be generated from Vivado MIG Example with vivado command
# generate_mem_files /home/xmartin/work/dpu-fpga/ -verbose -force
# though second memory is missing.

smi_file=$(pwd)/tmp_microblaze_mcs.smi

echo '<?xml version="1.0" encoding="UTF-8"?>                                                                                 ' >  $smi_file 
echo '<!-- Product Version: Vivado v2020.1 (64-bit)              -->                                                         ' >> $smi_file 
echo '<!-- SW Build 2902540 on Wed May 27 19:54:35 MDT 2020  -->                                                             ' >> $smi_file 
echo '<!--                                                         -->                                                       ' >> $smi_file 
echo '<!-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.   -->                                                       ' >> $smi_file 
echo '<!-- May 27 2020                                             -->                                                       ' >> $smi_file 
echo '<!--                                                         -->                                                       ' >> $smi_file 
echo '<!-- This file is generated by the software with the Tcl write_mem_info command. -->                                   ' >> $smi_file 
echo '<!-- Do not edit this file.                                                      -->                                   ' >> $smi_file 
echo '                                                                                                                       ' >> $smi_file 
echo '<MemInfoSimulation Version="1" Minor="1">                                                                              ' >> $smi_file 
echo '  <Processor Endianness="Little" InstPath="u_ddr4_mig_dram/inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/inst/microblaze_I">' >> $smi_file 
echo '    <AddressSpace Name="lmb_bram_I_ADDR_SPACE" ECC="NONE" Begin="0" End="98303">                                       ' >> $smi_file 
echo '      <BusBlock>                                                                                                       ' >> $smi_file 
echo '        <BitLane MemType="lmb_bram_I_MEM_DEVICE" MemType_DataWidth="32" MemType_AddressDepth="65536">                  ' >> $smi_file 
echo '          <DataWidth MSB="31" LSB="0"/>                                                                                ' >> $smi_file 
echo '          <AddressRange Begin="0" End="16383"/>                                                                        ' >> $smi_file 
echo '          <Parity ON="false" NumBits="0"/>                                                                             ' >> $smi_file 
echo '          <MemFile Name="bd_8dc4_lmb_bram_I_0.mem"/>                                                                   ' >> $smi_file 
echo '        </BitLane>                                                                                                     ' >> $smi_file 
echo '      </BusBlock>                                                                                                      ' >> $smi_file 
echo '      <BusBlock>                                                                                                       ' >> $smi_file 
echo '        <BitLane MemType="second_lmb_bram_I_MEM_DEVICE" MemType_DataWidth="32" MemType_AddressDepth="32768">           ' >> $smi_file
echo '          <DataWidth MSB="31" LSB="0"/>                                                                                ' >> $smi_file
echo '          <AddressRange Begin="0" End="8192"/>                                                                         ' >> $smi_file
echo '          <Parity ON="false" NumBits="0"/>                                                                             ' >> $smi_file
echo '          <MemFile Name="bd_8dc4_second_lmb_bram_I_0.mem"/>                                                            ' >> $smi_file
echo '        </BitLane>                                                                                                     ' >> $smi_file
echo '      </BusBlock>                                                                                                      ' >> $smi_file
echo '    </AddressSpace>                                                                                                    ' >> $smi_file
echo '  </Processor>                                                                                                         ' >> $smi_file
echo '  <Config>                                                                                                             ' >> $smi_file
echo '    <Option Name="Part" Val="xcvu9p-flgb2104-2-i"/>                                                                    ' >> $smi_file
echo '  </Config>                                                                                                            ' >> $smi_file
echo '  <DRC>                                                                                                                ' >> $smi_file
echo '    <Rule Name="RDADDRCHANGE" Val="false"/>                                                                            ' >> $smi_file
echo '  </DRC>                                                                                                               ' >> $smi_file
echo '</MemInfoSimulation>                                                                                                   ' >> $smi_file

$updatemem_exec -meminfo $smi_file -data $vivado_mig_ip_path/sw/calibration_0/Debug/calibration_ddr.elf -proc u_$vivado_mig_ip_name/inst/u_ddr4_mem_intfc/u_ddr_cal_riu/mcs0/inst/microblaze_I -force

#Move generated File in Simulation Folder
mv bd_8dc4_lmb_bram_I_0.mem        ./sim/modelsim/.
mv bd_8dc4_second_lmb_bram_I_0.mem ./sim/modelsim/.

################################################################################
# Clean Up
################################################################################
rm $vivado_tcl_file
rm $smi_file
rm vivado.jou
rm vivado.log
rm updatemem.jou
rm updatemem.log

################################################################################
# Launch Compilation of Modelsim
################################################################################
cd sim/modelsim/
$vsim_exec -c -do $questa_scripts/compile_ddr4_mig_dram.tcl

################################################################################
# Launch Simulation
################################################################################
$vsim_exec -do $questa_scripts/run_sim.tcl

cd -


