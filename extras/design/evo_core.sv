//===========================================================================
//  Copyright(c) Alorium Technology Group Inc., 2019
//  ALL RIGHTS RESERVED
//===========================================================================
//
// File name:  : evo_core.sv
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description : 
// 
//
//===========================================================================

`define FLASH

module evo_core
  #(parameter DC_COMPACT      =  1'h0, // Default is not Compact (10MxxDAF)
    parameter DC_FPGA_SIZE    = 8'h19, // Default is 10M25
    parameter FLASH_BYTE_FLIP = 1, // Flip the bits going to xlr8_flashload
    parameter EVO_INFO_MODEL_VAL   = 32'hc0ffee00, 
    parameter EVO_INFO_SERIAL_VAL  = 32'hc0ffee01,
    parameter EVO_INFO_PART_VAL    = 32'hc0ffee12,
    parameter EVO_INFO_FTYPE_VAL   = 32'hc0ffee10,
    parameter EVO_INFO_FSIZE_VAL   = 32'hc0ffee11,
    parameter EVO_INFO_FSPLY_VAL   = 32'hc0ffee12,
    parameter EVO_INFO_FFEAT_VAL   = 32'hc0ffee13,
    parameter EVO_INFO_FPACK_VAL   = 32'hc0ffee14,
    parameter EVO_INFO_FPINS_VAL   = 32'hc0ffee15,
    parameter EVO_INFO_FTEMP_VAL   = 32'hc0ffee16,
    parameter EVO_INFO_FSPED_VAL   = 32'hc0ffee17,
    parameter EVO_INFO_FOPTN_VAL   = 32'hc0ffee18,
    parameter EVO_INFO_VER_VAL     = 32'hc0ffee20,
    parameter EVO_INFO_SVN_VAL     = 32'hc0ffee21
    )  
   (
    // CLocks and Resets
    input  FPGA_CLK,
    input  FPGA_CLKEN,
    input  RESETN,
    
    // Dedicated bus between SAMD and FPGA
    inout  Z0,
    inout  Z1,
    inout  Z2,
    inout  Z3,
    inout  Z4,
    inout  Z5,
    inout  Z6,
    inout  Z7,
    inout  Z8,
    inout  Z9,
    
    // Extended connection so Castle-ated vias
    inout  E0,
    inout  E1,
    inout  E2,
    inout  E3,
    inout  E4,
    inout  E5,
    inout  E6,
    inout  E7,
    inout  E8,
    inout  E9,
    inout  E10,
    inout  E11,
    inout  E12,
    inout  E13,
    inout  E14,
    inout  E15,
    inout  E16,
    inout  E17,
    inout  E18,
    inout  E19,
    inout  E20,
    inout  E21,
    inout  E22,
    inout  E23,
    inout  E24,
    inout  E25,
    inout  E26,
    inout  E27,
    inout  E28,
    inout  E29,
    inout  E30,
    inout  E31,
    // Port G is also Castle-ated vias
    inout  G0,
    inout  G1,
    
    // Standard Feather D pins, Passed through the FPGA
    inout  D0,
    inout  D1,
    inout  D4,
    inout  D5,
    inout  D6,
    inout  D8,
    inout  D9,
    inout  D10, // Also JTAG 
    inout  D11, // Also JTAG 
    inout  D12, // Also JTAG 
    inout  D13, // Also JTAG 
    
    // Standard Feather D pins, sent from SAMD
    inout  FPGA_D0,
    inout  FPGA_D1,
    inout  FPGA_D4,
    inout  FPGA_D5,
    inout  FPGA_D6,
    inout  FPGA_D8,
    inout  FPGA_D9,
    inout  FPGA_D10,
    inout  FPGA_D11,
    inout  FPGA_D12,
    inout  FPGA_D13,
    
    // SPI bus, from SAMD to be passed through FPGA
    inout FPGA_MISO,
    inout FPGA_MOSI,
    inout FPGA_SCK,
    
    // Dedicated I2C bus between SAMD and FPGA
    inout  FPGA_SCL,
    inout  FPGA_SDA,
    
    // If HIGH, D[13:10] are JTAG pins
    input  JTAGEN,
    
    // SPI bus passed through the FPGA
    inout  MISO,
    inout  MOSI,
    inout  SCK
    );
   
   
   logic [31:0] reset_counter;
   logic        reset_n;
   logic        pwr_on_nrst;
   logic        pll_locked;
   logic        clk_bsp;
   logic        clk_60;
   logic        clk_120;
   logic        clk_16;
   logic        clk_32;
   logic        en16mhz;
   logic        en1mhz;

   wire [35:0] unused; // Tie off the unused bits in the port_pads bus
   
   //---------------------------------------------------------------------------
   // PORTMUX connections
   // Interface to IP blocks
   logic [PORT_D_DWIDTH-1:0]        port_d_pmux_dir;
   logic [PORT_D_DWIDTH-1:0]        port_d_pmux_out;
   logic [PORT_D_DWIDTH-1:0]        port_d_pmux_en;
   logic [PORT_D_DWIDTH-1:0]        port_d_pmux_in;
   
   logic [PORT_E_DWIDTH-1:0]        port_e_pmux_dir;
   logic [PORT_E_DWIDTH-1:0]        port_e_pmux_out;
   logic [PORT_E_DWIDTH-1:0]        port_e_pmux_en;
   logic [PORT_E_DWIDTH-1:0]        port_e_pmux_in;
   
   logic [PORT_F_DWIDTH-1:0]        port_f_pmux_dir;
   logic [PORT_F_DWIDTH-1:0]        port_f_pmux_out;
   logic [PORT_F_DWIDTH-1:0]        port_f_pmux_en;
   logic [PORT_F_DWIDTH-1:0]        port_f_pmux_in;
   
   logic [PORT_G_DWIDTH-1:0]        port_g_pmux_dir;
   logic [PORT_G_DWIDTH-1:0]        port_g_pmux_out;
   logic [PORT_G_DWIDTH-1:0]        port_g_pmux_en;
   logic [PORT_G_DWIDTH-1:0]        port_g_pmux_in;
   
   logic [PORT_Z_DWIDTH-1:0]        port_z_pmux_dir;
   logic [PORT_Z_DWIDTH-1:0]        port_z_pmux_out;
   logic [PORT_Z_DWIDTH-1:0]        port_z_pmux_en;
   logic [PORT_Z_DWIDTH-1:0]        port_z_pmux_in;

   logic                            xb_int;
   logic                            eic_swrst;

   //---------------------------------------------------------------------------
   // CSR Avalon bus variables
   logic [MADR_MSB-1:0]   avm_bsp_csr_address;
   logic                  avm_bsp_csr_read;                 
   logic                  avm_bsp_csr_readdatavalid;
   logic                  avm_bsp_csr_waitrequest;
   logic                  avm_bsp_csr_write;                 
   logic [CSR_DWIDTH-1:0] avm_bsp_csr_readdata;
   logic [CSR_DWIDTH-1:0] avm_bsp_csr_writedata;


   //======================================================================
   // Instance Name:  evo_clkrst_inst
   // Module Type:    evo_clkrst
   //----------------------------------------------------------------------
   // 
   // 
   //======================================================================

   localparam CLOCK_SELECT = 1; // 0=16MHz, 1=60MHz, 2=120MHz, 3=reserved 

   //   localparam RESET_DELAY       = 32'h00055000; // 344142 = 0x5404E
   localparam RESET_DELAY       = 32'h00000010; // temp small delay


   
   evo_clkrst 
     #(.CLOCK_SELECT (CLOCK_SELECT),
       .RESET_DELAY  (RESET_DELAY)
       )
   evo_clkrst_inst 
     (// Inputs
      .clk_in        (FPGA_CLK),
      .core_rstn     (RESETN),
      // Outputs
      .pwr_on_nrst   (pwr_on_nrst),
      .reset_n       (reset_n),
      .pll_locked    (pll_locked),
      .clk_bsp       (clk_bsp),
      .clk_60        (clk_60),
      .clk_120       (clk_120),
      .clk_16        (clk_16),
      .clk_32        (clk_32),
      .en16mhz       (en16mhz),
      .en1mhz        (en1mhz)
      );


   //======================================================================
   // Instance Name:  evo_bsp_inst
   // Module Type:    evo_bsp
   //----------------------------------------------------------------------
   // 
   // This module contains all of the standard support logic for the Evo, 
   // with the exception of the clocks module.
   //======================================================================
   evo_bsp
     #(.DC_COMPACT      (DC_COMPACT),
       .DC_FPGA_SIZE    (DC_FPGA_SIZE),
       .FLASH_BYTE_FLIP (FLASH_BYTE_FLIP), // Flip the bits going to xlr8_flashload
       .EVO_INFO_MODEL_VAL  (EVO_INFO_MODEL_VAL),  
       .EVO_INFO_SERIAL_VAL (EVO_INFO_SERIAL_VAL), 
       .EVO_INFO_PART_VAL   (EVO_INFO_PART_VAL),   
       .EVO_INFO_FTYPE_VAL  (EVO_INFO_FTYPE_VAL),  
       .EVO_INFO_FSIZE_VAL  (EVO_INFO_FSIZE_VAL),  
       .EVO_INFO_FSPLY_VAL  (EVO_INFO_FSPLY_VAL),  
       .EVO_INFO_FFEAT_VAL  (EVO_INFO_FFEAT_VAL),  
       .EVO_INFO_FPACK_VAL  (EVO_INFO_FPACK_VAL),  
       .EVO_INFO_FPINS_VAL  (EVO_INFO_FPINS_VAL),  
       .EVO_INFO_FTEMP_VAL  (EVO_INFO_FTEMP_VAL),  
       .EVO_INFO_FSPED_VAL  (EVO_INFO_FSPED_VAL),  
       .EVO_INFO_FOPTN_VAL  (EVO_INFO_FOPTN_VAL),  
       .EVO_INFO_VER_VAL    (EVO_INFO_VER_VAL),    
       .EVO_INFO_SVN_VAL    (EVO_INFO_SVN_VAL)    
       )
   evo_bsp_inst
     (// CLocks and Resets
      .clk       (clk_bsp),
      .clken     (1'b1),
      .reset_n   (reset_n),
      .en16mhz   (en16mhz),
      
      // Dedicated I2C bus between SAMD and FPGA
      .FPGA_SCL  (FPGA_SCL),
      .FPGA_SDA  (FPGA_SDA),
      
      // CSR bus (Avalon MM Master)
      .avm_bsp_csr_address       (avm_bsp_csr_address),
      .avm_bsp_csr_read          (avm_bsp_csr_read),
      .avm_bsp_csr_readdatavalid (avm_bsp_csr_readdatavalid),
      .avm_bsp_csr_waitrequest   (avm_bsp_csr_waitrequest),
      .avm_bsp_csr_write         (avm_bsp_csr_write),
      .avm_bsp_csr_writedata     (avm_bsp_csr_writedata),
      .avm_bsp_csr_readdata      (avm_bsp_csr_readdata),

      // PINMUX Connections      
      .port_d_pmux_dir_i              (port_d_pmux_dir),
      .port_d_pmux_out_i              (port_d_pmux_out),
      .port_d_pmux_en_i               (port_d_pmux_en),
      .port_d_pmux_in_o               (port_d_pmux_in),
      .port_e_pmux_dir_i              (port_e_pmux_dir),
      .port_e_pmux_out_i              (port_e_pmux_out),
      .port_e_pmux_en_i               (port_e_pmux_en),
      .port_e_pmux_in_o               (port_e_pmux_in),
      .port_f_pmux_dir_i              (port_f_pmux_dir),
      .port_f_pmux_out_i              (port_f_pmux_out),
      .port_f_pmux_en_i               (port_f_pmux_en),
      .port_f_pmux_in_o               (port_f_pmux_in),
      .port_g_pmux_dir_i              (port_g_pmux_dir),
      .port_g_pmux_out_i              (port_g_pmux_out),
      .port_g_pmux_en_i               (port_g_pmux_en),
      .port_g_pmux_in_o               (port_g_pmux_in),
      .port_z_pmux_dir_i              (port_z_pmux_dir),
      .port_z_pmux_out_i              (port_z_pmux_out),
      .port_z_pmux_en_i               (port_z_pmux_en),
      .port_z_pmux_in_o               (port_z_pmux_in),

      // Interrupts
      .xb_int_i                       (xb_int),
      .eic_swrst_o                    (eic_swrst),

      // GPIO Connections
      .port_d_pads ({// Port D
                                                SCK,     MOSI,       // [ 25: 24]
                     MISO,                           unused[22:16],  // [ 23: 16]
                     unused[15],    unused[14], D13,      D12,       // [ 15: 12]
                     D11,           D10,        D9,       D8,        // [ 11:  8]
                     unused[7],     D6,         D5,       D4,        // [  7:  4]
                     unused[4],     unused[3],  D1,       D0         // [  3:  0]
                     }),
      .port_e_pads ({// Port E
                     E31,E30,E29,E28,E27,E26,E25,E24,                 // [ 31: 24]
                     E23,E22,E21,E20,E19,E18,E17,E16,                 // [ 23: 16]
                     E15,E14,E13,E12,E11,E10,E9, E8,                  // [ 15:  8]
                     E7, E6, E5, E4, E3, E2, E1, E0                   // [  7:  0]
                     }),
      .port_f_pads ({// Port F
                                                FPGA_SCK,FPGA_MOSI,   // [ 25: 24]
                     FPGA_MISO,                      unused[34:28],   // [ 23: 16]
                     unused[27],    unused[26], FPGA_D13, FPGA_D12,   // [ 15: 12]
                     FPGA_D11,      FPGA_D10,   FPGA_D9,  FPGA_D8,    // [ 11:  8]
                     unused[25],    FPGA_D6,    FPGA_D5,  FPGA_D4,    // [  7:  4]
                     unused[24],    unused[23], FPGA_D1,  FPGA_D0     // [  3:  0]
                     }),
      .port_g_pads ({// Port G
                     G1, G0                                           // [  1:  0]
                     }),
      .port_z_pads ({// Port Z
                                             Z9, Z8,                  // [  9:  8]
                     Z7, Z6, Z5, Z4, Z3, Z2, Z1, Z0                   // [  7:  0]
                     })
      );
   wire unok = &{1'b0, unused[35:0],1'b0};

   
   //======================================================================
   // Instance Name:  evo_xb_inst
   // Module Type:    evo_xb
   //----------------------------------------------------------------------
   //
   // The evo_xb module is the top level wrapper for the user custom
   // logic. Based on a evo_xb template, which provides all of the I/O
   // and infrastructure the user needs, the evo_xb can be modified
   // however the user likes.
   //
   // ======================================================================

   // In older versions of evo_xb the interrupt connections did not
   // exist. To use interrupts in the evo_xb, define EVO_XB_INTERRUPTS
   // so that evo_xb is connected to the interrupt logic. Add a line
   // like the following to your QSF file:
   //
   // set_global_assignment -name VERILOG_MACRO "EVO_XB_INTERRUPS=1"
   //
`ifndef EVO_XB_INTERRUPTS
   always_comb xb_int = 1'b0;
`endif   

   evo_xb
   evo_xb_inst
     (// Basic clock and reset
      .clk                            (clk_bsp),
      .reset_n                        (reset_n),
      // Other clocks and resets
      .pwr_on_nrst                    (pwr_on_nrst),
      .pll_locked                     (pll_locked),
      .clk_bsp                        (clk_bsp),
      .clk_60                         (clk_60),
      .clk_120                        (clk_120),
      .clk_16                         (clk_16),
      .clk_32                         (clk_32),
      .en16mhz                        (en16mhz),
      .en1mhz                         (en1mhz),
      // PMUX connections
      .port_d_pmux_dir_o              (port_d_pmux_dir),
      .port_d_pmux_out_o              (port_d_pmux_out),
      .port_d_pmux_en_o               (port_d_pmux_en),
      .port_d_pmux_in_i               (port_d_pmux_in),
      .port_e_pmux_dir_o              (port_e_pmux_dir),
      .port_e_pmux_out_o              (port_e_pmux_out),
      .port_e_pmux_en_o               (port_e_pmux_en),
      .port_e_pmux_in_i               (port_e_pmux_in),
      .port_f_pmux_dir_o              (port_f_pmux_dir),
      .port_f_pmux_out_o              (port_f_pmux_out),
      .port_f_pmux_en_o               (port_f_pmux_en),
      .port_f_pmux_in_i               (port_f_pmux_in),
      .port_g_pmux_dir_o              (port_g_pmux_dir),
      .port_g_pmux_out_o              (port_g_pmux_out),
      .port_g_pmux_en_o               (port_g_pmux_en),
      .port_g_pmux_in_i               (port_g_pmux_in),
      .port_z_pmux_dir_o              (port_z_pmux_dir),
      .port_z_pmux_out_o              (port_z_pmux_out),
      .port_z_pmux_en_o               (port_z_pmux_en),
      .port_z_pmux_in_i               (port_z_pmux_in),
`ifdef EVO_XB_INTERRUPTS
      // Interrupts
      .xb_int_o                       (xb_int),
      .eic_swrst_i                    (eic_swrst),
`endif      
      // CSR bus (Avalon MM Slave)
      .avs_csr_address                (avm_bsp_csr_address[MADR_MSB-1:MADR_LSB]),
      .avs_csr_read                   (avm_bsp_csr_read),
      .avs_csr_readdatavalid          (avm_bsp_csr_readdatavalid),
      .avs_csr_waitrequest            (avm_bsp_csr_waitrequest),
      .avs_csr_write                  (avm_bsp_csr_write),
      .avs_csr_writedata              (avm_bsp_csr_writedata),
      .avs_csr_readdata               (avm_bsp_csr_readdata)
      );

   
   
endmodule
