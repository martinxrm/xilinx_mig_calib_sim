////////////////////////////////////////////////////////////////////////////////
// 
// Top Level testbench Memory Controller 
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps
`default_nettype none
`include "../../../backend/Xilinx/Vivado/ddr4_mig_dram/imports/arch_package.sv"
`include "../../../backend/Xilinx/Vivado/ddr4_mig_dram/imports/interface.sv"

module tb_ddr4_mig_dram();

   /////////////////////////////////////////////////////////////////////////////
   // AXI Localparameters
   /////////////////////////////////////////////////////////////////////////////
   localparam AXI_MIG_DATA_W = 64;
   localparam AXI_MIG_WSTR_W = 8;   
   localparam AXI_MIG_ADDR_W = 30;

   /////////////////////////////////////////////////////////////////////////////
   // DDR Model Localparameters
   /////////////////////////////////////////////////////////////////////////////
   localparam ADDR_WIDTH         = 17;
   localparam DQ_WIDTH           = 8;
   localparam DQS_WIDTH          = 1;
   localparam DM_WIDTH           = 1;
   localparam DRAM_WIDTH         = 8;
   localparam tCK                = 833 ; //DDR4 interface clock period in ps
   localparam real SYSCLK_PERIOD = tCK; 
   localparam NUM_PHYSICAL_PARTS = (DQ_WIDTH/DRAM_WIDTH) ;
   localparam CLAMSHELL_PARTS    = (NUM_PHYSICAL_PARTS/2);
   localparam ODD_PARTS          = ((CLAMSHELL_PARTS*2) < NUM_PHYSICAL_PARTS) ? 1 : 0;

   parameter  RANK_WIDTH         = 1;
   parameter  CS_WIDTH           = 1;
   parameter  ODT_WIDTH          = 1;
   parameter  CA_MIRROR          = "OFF";

   import arch_package::*;
   parameter UTYPE_density CONFIGURED_DENSITY = _8G;
   
   /////////////////////////////////////////////////////////////////////////////
   // Wire And Registers Declaration
   /////////////////////////////////////////////////////////////////////////////
   //Source clocks
   reg                         src_sys_clk ;                                    // Source System Clock    
   reg                         src_sys_rst ;                                    // Source System reset   
   bit                         model_en_bit;                                    // DDR4 SDRAM Model Enable command
   tri                         model_en_tri;                                    // DDR4 SDRAM Model Enable command
   //Misc.
   reg [31:0]                  dbg_ddr4_cmd_name;
   //Address Mirroring on PCB
   reg  [ADDR_WIDTH-1:0]       pcb_ddr4_addr_mod[RANK_WIDTH-1:0];   
   reg  [16:0]                 pcb_ddr4_addr[1:0];                              // PCB DDR4 - Address
   reg  [1:0]                  pcb_ddr4_ba  [1:0];                              // PCB DDR4 - Bank Address
   reg  [1:0]                  pcb_ddr4_bg  [1:0];                              // PCB DDR4 - bank Group
   //Memory Controller
   wire                        mig_sys_rst      ;                               // System Asynchronous reset
   wire                        mig_sys_clk_p    ;                               // System Differential clock 
   wire                        mig_sys_clk_n    ;                               // System Differential clock 
                                                                                
   wire                        mig_ddr4_act_n   ;                               // DDR4 - Activate
   wire [16:0]                 mig_ddr4_addr    ;                               // DDR4 - Address
   wire [1:0]                  mig_ddr4_ba      ;                               // DDR4 - Bank Address
   wire [1:0]                  mig_ddr4_bg      ;                               // DDR4 - bank Group
   wire [0:0]                  mig_ddr4_cke     ;                               // DDR4 - Clock Enable
   wire [0:0]                  mig_ddr4_odt     ;                               // DDR4 - On Die Termination
   wire [0:0]                  mig_ddr4_cs_n    ;                               // DDR4 - Chip Select
   wire [0:0]                  mig_ddr4_ck_t    ;                               // DDR4 - Differential clock
   wire [0:0]                  mig_ddr4_ck_c    ;                               // DDR4 - Differential clock
   wire                        mig_ddr4_rst_n   ;                               // DDR4 - Reset
   wire [0:0]                  mig_ddr4_dm_dbi_n;                               // DDR4 - Data Mask/Data inversion
   wire [7:0]                  mig_ddr4_dq      ;                               // DDR4 - Data
   wire [0:0]                  mig_ddr4_dqs_c   ;                               // DDR4 - differential Data strobe
   wire [0:0]                  mig_ddr4_dqs_t   ;                               // DDR4 - differential Data Strobe

   wire                        mig_ui_clk       ;                               // User Interface clock
   wire                        mig_ui_rst       ;                               // User Interface Sycnhronized reset
   wire                        mig_init_done    ;                               // Initialization Calibration DONE
                               
   wire                        s_axi_mig_aresetn  ;                             // AXI reset
   wire [3:0]                  s_axi_mig_awid     ;                             // AXI Write Address  channel 
   wire [AXI_MIG_ADDR_W-1:0]   s_axi_mig_awaddr   ;                             // AXI Write Address  channel 
   wire [7:0]                  s_axi_mig_awlen    ;                             // AXI Write Address  channel 
   wire [2:0]                  s_axi_mig_awsize   ;                             // AXI Write Address  channel 
   wire [1:0]                  s_axi_mig_awburst  ;                             // AXI Write Address  channel 
   wire [0:0]                  s_axi_mig_awlock   ;                             // AXI Write Address  channel 
   wire [3:0]                  s_axi_mig_awcache  ;                             // AXI Write Address  channel 
   wire [2:0]                  s_axi_mig_awprot   ;                             // AXI Write Address  channel 
   wire [3:0]                  s_axi_mig_awqos    ;                             // AXI Write Address  channel 
   wire                        s_axi_mig_awvalid  ;                             // AXI Write Address  channel 
   wire                        s_axi_mig_awready  ;                             // AXI Write Address  channel 
   wire [AXI_MIG_DATA_W-1:0]   s_axi_mig_wdata    ;                             // AXI Write Data     channel
   wire [AXI_MIG_WSTR_W-1:0]   s_axi_mig_wstrb    ;                             // AXI Write Data     channel
   wire                        s_axi_mig_wlast    ;                             // AXI Write Data     channel
   wire                        s_axi_mig_wvalid   ;                             // AXI Write Data     channel
   wire                        s_axi_mig_wready   ;                             // AXI Write Data     channel
   wire [3:0]                  s_axi_mig_bid      ;                             // AXI Write Response channel
   wire [1:0]                  s_axi_mig_bresp    ;                             // AXI Write Response channel
   wire                        s_axi_mig_bvalid   ;                             // AXI Write Response channel
   wire                        s_axi_mig_bready   ;                             // AXI Write Response channel
   wire [3:0]                  s_axi_mig_arid     ;                             // AXI Read  Address  channel
   wire [AXI_MIG_ADDR_W-1:0]   s_axi_mig_araddr   ;                             // AXI Read  Address  channel
   wire [7:0]                  s_axi_mig_arlen    ;                             // AXI Read  Address  channel
   wire [2:0]                  s_axi_mig_arsize   ;                             // AXI Read  Address  channel
   wire [1:0]                  s_axi_mig_arburst  ;                             // AXI Read  Address  channel
   wire [0:0]                  s_axi_mig_arlock   ;                             // AXI Read  Address  channel
   wire [3:0]                  s_axi_mig_arcache  ;                             // AXI Read  Address  channel
   wire [2:0]                  s_axi_mig_arprot   ;                             // AXI Read  Address  channel
   wire [3:0]                  s_axi_mig_arqos    ;                             // AXI Read  Address  channel
   wire                        s_axi_mig_arvalid  ;                             // AXI Read  Address  channel
   wire                        s_axi_mig_arready  ;                             // AXI Read  Address  channel
   wire [3:0]                  s_axi_mig_rid      ;                             // AXI Read  Data     channel
   wire [AXI_MIG_DATA_W-1:0]   s_axi_mig_rdata    ;                             // AXI Read  Data     channel
   wire [1:0]                  s_axi_mig_rresp    ;                             // AXI Read  Data     channel
   wire                        s_axi_mig_rlast    ;                             // AXI Read  Data     channel
   wire                        s_axi_mig_rvalid   ;                             // AXI Read  Data     channel
   wire                        s_axi_mig_rready   ;                             // AXI Read  Data     channel
   // Debug Port
   wire                        dbg_clk            ;                             // Debug Port - Clock
   wire [511:0]                dbg_bus            ;                             // Debug Port - Bus                                             
   
   /////////////////////////////////////////////////////////////////////////////
   //Clock And reset
   /////////////////////////////////////////////////////////////////////////////
   initial
     src_sys_clk = 1'b0;
   always
     src_sys_clk = #(2999/2.0) ~src_sys_clk;
  
   assign mig_sys_clk_p =  src_sys_clk;
   assign mig_sys_clk_n = ~src_sys_clk;

   initial
     begin
        src_sys_rst  = 1'b0;
        #200
        src_sys_rst  = 1'b1;
        model_en_bit = 1'b0; 
        #5
        model_en_bit = 1'b1;
        #200;
        src_sys_rst  = 1'b0;
        #100;
     end // initial begin

   assign mig_sys_rst  = src_sys_rst;
   assign model_en_tri = model_en_bit;
   
   /////////////////////////////////////////////////////////////////////////////
   // Address Mirroring
   /////////////////////////////////////////////////////////////////////////////
   always @(*)
     begin
        pcb_ddr4_addr[0] = mig_ddr4_addr;
        pcb_ddr4_ba  [0] = mig_ddr4_ba  ;
        pcb_ddr4_bg  [0] = mig_ddr4_bg  ;
        if(CA_MIRROR == "ON")
          begin
             pcb_ddr4_addr[1] = {mig_ddr4_addr[ADDR_WIDTH-1:14],
                                 mig_ddr4_addr[11], mig_ddr4_addr[12]  ,
                                 mig_ddr4_addr[13], mig_ddr4_addr[10:9],
                                 mig_ddr4_addr[7] , mig_ddr4_addr[8]   ,
                                 mig_ddr4_addr[5] , mig_ddr4_addr[6]   ,
                                 mig_ddr4_addr[3] , mig_ddr4_addr[4]   ,
                                 mig_ddr4_addr[2:0]};
             pcb_ddr4_ba  [1] = {mig_ddr4_ba[0],mig_ddr4_ba[1]};
             pcb_ddr4_bg  [1] = {mig_ddr4_bg[0],mig_ddr4_bg[1]};
          end
        else
          begin
             pcb_ddr4_addr[1] = mig_ddr4_addr;
             pcb_ddr4_ba  [1] = mig_ddr4_ba  ;
             pcb_ddr4_bg  [1] = mig_ddr4_bg  ;
          end
     end
   
   /////////////////////////////////////////////////////////////////////////////
   // WIP
   /////////////////////////////////////////////////////////////////////////////   
   assign s_axi_mig_aresetn = 1;
   assign s_axi_mig_awid    = 0; 
   assign s_axi_mig_awaddr  = 0; 
   assign s_axi_mig_awlen   = 0; 
   assign s_axi_mig_awsize  = 0; 
   assign s_axi_mig_awburst = 0; 
   assign s_axi_mig_awlock  = 0; 
   assign s_axi_mig_awcache = 0; 
   assign s_axi_mig_awprot  = 0; 
   assign s_axi_mig_awqos   = 0; 
   assign s_axi_mig_awvalid = 0; 
   assign s_axi_mig_wdata   = 0;
   assign s_axi_mig_wstrb   = 0;
   assign s_axi_mig_wlast   = 0;
   assign s_axi_mig_wvalid  = 0;
   assign s_axi_mig_wready  = 0;
   assign s_axi_mig_bready  = 0;
   assign s_axi_mig_arid    = 0;
   assign s_axi_mig_araddr  = 0;
   assign s_axi_mig_arlen   = 0;
   assign s_axi_mig_arsize  = 0;
   assign s_axi_mig_arburst = 0;
   assign s_axi_mig_arlock  = 0;
   assign s_axi_mig_arcache = 0;
   assign s_axi_mig_arprot  = 0;
   assign s_axi_mig_arqos   = 0;
   assign s_axi_mig_arvalid = 0;
   assign s_axi_mig_rready  = 0;
   
   /////////////////////////////////////////////////////////////////////////////
   // DDR4 MIG - DRAM
   /////////////////////////////////////////////////////////////////////////////
   ddr4_mig_dram u_ddr4_mig_dram (
     //global Signals
     .sys_rst                  (mig_sys_rst        ),                           // [in]  System Asynchronous reset
     .c0_sys_clk_p             (mig_sys_clk_p      ),                           // [in]  System Differential clock 
     .c0_sys_clk_n             (mig_sys_clk_n      ),                           // [in]  System Differential clock 
     //DDR4 Interface
     .c0_ddr4_act_n            (mig_ddr4_act_n     ),                           // [out] DDR4 - Activate
     .c0_ddr4_adr              (mig_ddr4_addr      ),                           // [out] DDR4 - Address
     .c0_ddr4_ba               (mig_ddr4_ba        ),                           // [out] DDR4 - Bank Address
     .c0_ddr4_bg               (mig_ddr4_bg        ),                           // [out] DDR4 - bank Group
     .c0_ddr4_cke              (mig_ddr4_cke       ),                           // [out] DDR4 - Clock Enable
     .c0_ddr4_odt              (mig_ddr4_odt       ),                           // [out] DDR4 - On Die Termination
     .c0_ddr4_cs_n             (mig_ddr4_cs_n      ),                           // [out] DDR4 - Chip Select
     .c0_ddr4_ck_t             (mig_ddr4_ck_t      ),                           // [out] DDR4 - Differential clock
     .c0_ddr4_ck_c             (mig_ddr4_ck_c      ),                           // [out] DDR4 - Differential clock
     .c0_ddr4_reset_n          (mig_ddr4_rst_n     ),                           // [out] DDR4 - Reset
     .c0_ddr4_dm_dbi_n         (mig_ddr4_dm_dbi_n  ),                           // [out] DDR4 - Data Mask/Data inversion
     .c0_ddr4_dq               (mig_ddr4_dq        ),                           // [inout] DDR4 - Data
     .c0_ddr4_dqs_c            (mig_ddr4_dqs_c     ),                           // [inout] DDR4 - differential Data strobe
     .c0_ddr4_dqs_t            (mig_ddr4_dqs_t     ),                           // [inout] DDR4 - differential Data Strobe
     //User Interface
     .c0_ddr4_ui_clk           (mig_ui_clk         ),                           // [out] User Interface clock
     .c0_ddr4_ui_clk_sync_rst  (mig_ui_rst         ),                           // [out] User Interface Sycnhronized reset
     .c0_init_calib_complete   (mig_init_done      ),                           // [out] Initialization Calibration DONE
     // Slave AXI Interface (synchronized to mig_ui_clk)
     .c0_ddr4_aresetn          (s_axi_mig_aresetn  ),                           // [in]  AXI reset
     .c0_ddr4_s_axi_awid       (s_axi_mig_awid     ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awaddr     (s_axi_mig_awaddr   ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awlen      (s_axi_mig_awlen    ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awsize     (s_axi_mig_awsize   ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awburst    (s_axi_mig_awburst  ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awlock     (s_axi_mig_awlock   ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awcache    (s_axi_mig_awcache  ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awprot     (s_axi_mig_awprot   ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awqos      (s_axi_mig_awqos    ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awvalid    (s_axi_mig_awvalid  ),                           // [in]  AXI Write Address  channel 
     .c0_ddr4_s_axi_awready    (s_axi_mig_awready  ),                           // [out] AXI Write Address  channel 
     .c0_ddr4_s_axi_wdata      (s_axi_mig_wdata    ),                           // [in]  AXI Write Data     channel
     .c0_ddr4_s_axi_wstrb      (s_axi_mig_wstrb    ),                           // [in]  AXI Write Data     channel
     .c0_ddr4_s_axi_wlast      (s_axi_mig_wlast    ),                           // [in]  AXI Write Data     channel
     .c0_ddr4_s_axi_wvalid     (s_axi_mig_wvalid   ),                           // [in]  AXI Write Data     channel
     .c0_ddr4_s_axi_wready     (s_axi_mig_wready   ),                           // [in]  AXI Write Data     channel
     .c0_ddr4_s_axi_bid        (s_axi_mig_bid      ),                           // [out] AXI Write Response channel
     .c0_ddr4_s_axi_bresp      (s_axi_mig_bresp    ),                           // [out] AXI Write Response channel
     .c0_ddr4_s_axi_bvalid     (s_axi_mig_bvalid   ),                           // [out] AXI Write Response channel
     .c0_ddr4_s_axi_bready     (s_axi_mig_bready   ),                           // [in]  AXI Write Response channel
     .c0_ddr4_s_axi_arid       (s_axi_mig_arid     ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_araddr     (s_axi_mig_araddr   ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arlen      (s_axi_mig_arlen    ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arsize     (s_axi_mig_arsize   ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arburst    (s_axi_mig_arburst  ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arlock     (s_axi_mig_arlock   ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arcache    (s_axi_mig_arcache  ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arprot     (s_axi_mig_arprot   ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arqos      (s_axi_mig_arqos    ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arvalid    (s_axi_mig_arvalid  ),                           // [in]  AXI Read  Address  channel
     .c0_ddr4_s_axi_arready    (s_axi_mig_arready  ),                           // [out] AXI Read  Address  channel
     .c0_ddr4_s_axi_rid        (s_axi_mig_rid      ),                           // [out] AXI Read  Data     channel
     .c0_ddr4_s_axi_rdata      (s_axi_mig_rdata    ),                           // [out] AXI Read  Data     channel
     .c0_ddr4_s_axi_rresp      (s_axi_mig_rresp    ),                           // [out] AXI Read  Data     channel
     .c0_ddr4_s_axi_rlast      (s_axi_mig_rlast    ),                           // [out] AXI Read  Data     channel
     .c0_ddr4_s_axi_rvalid     (s_axi_mig_rvalid   ),                           // [out] AXI Read  Data     channel
     .c0_ddr4_s_axi_rready     (s_axi_mig_rready   ),                           // [in]  AXI Read  Data     channel
     // Debug Port
     .dbg_clk                  (dbg_clk            ),                           // [in]  Debug Port - Clock
     .dbg_bus                  (dbg_bus            )                            // [out] Debug Port - Bus
   );

   /////////////////////////////////////////////////////////////////////////////
   // DDR Access decoding for debug purpose
   /////////////////////////////////////////////////////////////////////////////   
   localparam MRS       = 3'b000;
   localparam REF       = 3'b001;
   localparam PRE       = 3'b010;
   localparam ACT       = 3'b011;
   localparam WR        = 3'b100;
   localparam RD        = 3'b101;
   localparam ZQC       = 3'b110;
   localparam NOP       = 3'b111;
   
   always @(*)
     begin
        if (mig_ddr4_cs_n == 1'b1)
          dbg_ddr4_cmd_name = "DSEL";
        else
          begin
             if (mig_ddr4_act_n)
               begin
                  casez (pcb_ddr4_addr_mod[0][16:14])
                    MRS:     dbg_ddr4_cmd_name = "MRS";
                    REF:     dbg_ddr4_cmd_name = "REF";
                    PRE:     dbg_ddr4_cmd_name = "PRE";
                    WR:      dbg_ddr4_cmd_name = "WR";
                    RD:      dbg_ddr4_cmd_name = "RD";
                    ZQC:     dbg_ddr4_cmd_name = "ZQC";
                    NOP:     dbg_ddr4_cmd_name = "NOP";
                    default: dbg_ddr4_cmd_name = "***";
                  endcase // casez (pcb_ddr4_addr_mod[0][16:14])
               end // if (c0_ddr4_act_n)
             else
               dbg_ddr4_cmd_name = "ACT";
          end // else: !if(c0_ddr4_cs_n == 4'b1111)
     end // always @ if

   /////////////////////////////////////////////////////////////////////////////
   // DDR4 Memory Interface
   /////////////////////////////////////////////////////////////////////////////
   genvar r;   // Rank Index in the dimm
   genvar i;   // DRAM Index in the Rank
   genvar s;   // bit  Index  
   genvar rnk; // Rank Index in memory controller

   generate
   for (rnk = 0; rnk < CS_WIDTH; rnk++)
     begin:rankup
        always @(*)
          begin
             if (mig_ddr4_act_n)
               begin
                  casez (pcb_ddr4_addr[0][16:14])
                    WR, RD : pcb_ddr4_addr_mod[rnk] = pcb_ddr4_addr[rnk] & 18'h1C7FF;
                    default: pcb_ddr4_addr_mod[rnk] = pcb_ddr4_addr[rnk];
                  endcase // casez (mig_ddr4_addr[0][16:14])
               end
             else
               pcb_ddr4_addr_mod[rnk] = pcb_ddr4_addr[rnk];
          end // always @ begin
     end // block: rankup
   endgenerate
   
   DDR4_if #(.CONFIGURED_DQ_BITS(8)) iDDR4[0:(RANK_WIDTH*NUM_PHYSICAL_PARTS)-1]();

   //DDR4 Memory Instanciation   
   for (r = 0; r < RANK_WIDTH; r++)
     begin:memModels_Ri1
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++)
          begin:memModel1
            ddr4_model #(
              .CONFIGURED_DQ_BITS (8                        ),
              .CONFIGURED_DENSITY (CONFIGURED_DENSITY       )
            )u_ddr4_model(
              .model_enable (model_en_tri                   ),
              .iDDR4        (iDDR4[(r*NUM_PHYSICAL_PARTS)+i])
            );
          end
     end // block: memModels_Ri1
   
   // DDR4 interface signals assigment
   for (r = 0; r < RANK_WIDTH; r++)
     begin:tranDQ2
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++)
          begin:tranDQ12
             for (s = 0; s < 8; s++)
               begin:tranDQ2
                  tran bidiDQ(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQ[s], mig_ddr4_dq[s+i*8]);
               end
          end
     end
   

   for (r = 0; r < RANK_WIDTH; r++)
     begin:tranDQS2
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++)
          begin:tranDQS12
             tran bidiDQS (iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_t, mig_ddr4_dqs_t[i]);
             tran bidiDQS_(iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DQS_c, mig_ddr4_dqs_c[i]);
             tran bidiDM  (iDDR4[(r*NUM_PHYSICAL_PARTS)+i].DM_n , mig_ddr4_dm_dbi_n[i]);
          end
     end

   
   for (r = 0; r < RANK_WIDTH; r++)
     begin:ADDR_RANKS
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++)
          begin:ADDR_R
           assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].BG      = pcb_ddr4_bg[r];
           assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].BA      = pcb_ddr4_ba[r];
           assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ADDR_17 = (ADDR_WIDTH == 18) ? pcb_ddr4_addr_mod[r][ADDR_WIDTH-1] : 1'b0;
           assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ADDR    = pcb_ddr4_addr_mod[r][13:0];
           assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CS_n    = mig_ddr4_cs_n[r];
          end
     end
   

   for (r = 0; r < RANK_WIDTH; r++)
     begin:tranADCTL_RANKS1
        for (i = 0; i < NUM_PHYSICAL_PARTS; i++)
          begin:tranADCTL1
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CK        ={mig_ddr4_ck_t, mig_ddr4_ck_c};
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ACT_n     = mig_ddr4_act_n;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RAS_n_A16 = pcb_ddr4_addr_mod[r][16];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CAS_n_A15 = pcb_ddr4_addr_mod[r][15];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].WE_n_A14  = pcb_ddr4_addr_mod[r][14];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].CKE       = mig_ddr4_cke[r];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ODT       = mig_ddr4_odt[r];
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PARITY    = 1'b0;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].TEN       = 1'b0;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].ZQ        = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].PWR       = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_CA   = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].VREF_DQ   = 1'b1;
            assign iDDR4[(r*NUM_PHYSICAL_PARTS)+ i].RESET_n   = mig_ddr4_rst_n;
         end
      end

   initial
     begin
        @(posedge mig_init_done);
        @(posedge src_sys_clk);
        $display("Simulation End - MIG Initialization detected");
        $stop;
     end
   
endmodule // tb_ddr4_mig_dram
