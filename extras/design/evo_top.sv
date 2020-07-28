//===========================================================================
//  Copyright(c) Alorium Technology Group Inc., 2019
//  ALL RIGHTS RESERVED
//===========================================================================
//
// File name:  : evo_top.v
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description : 
// 
//   The very top level of the EVO FPGA. This module defines the I/O
//   pins of the FPGA and then instantiates one of the many evo_top
//   modules that then have theactual functionality in them. The
//   evo_top to be included is determined by defining one of the
//   EVO_COR_* variables.
//
//===========================================================================
//
// The following package files should be read and parsed first, before other 
// design files, so that the parameters, structures, etc are defined before 
// they are used. Here is how they are specified in the simulation Makefile:
//
// EVO_SRC_FILES += $(EVO_HOME)/design/evo_addr_pkg.sv
// EVO_SRC_FILES += $(EVO_HOME)/design/evo_const_pkg.sv
// EVO_SRC_FILES += $(EVO_HOME)/design/evo_bsp_pkg.sv
// EVO_SRC_FILES += $(EVO_HOME)/xb/OpenEvo/$(OPENEVO)/extras/design/evo_xb_addr_pkg.sv

module evo_top
  #(
    parameter DC_COMPACT           =  1'h0,  // Default is not Compact (10MxxDAF)
    parameter DC_FPGA_SIZE         = 8'h19,  // Default is 10M25
    parameter FLASH_BYTE_FLIP      = 1,      // Flip the bits going to xlr8_flashload
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
    input        FPGA_CLK,
    input        FPGA_CLKEN,
    input        RESETN,
    
    // Dedicated bus between SAMD and FPGA
    inout        Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9,
    
    // Extended connection to Castle-ated vias
    inout        E0, E1 , E2, E3, E4, E5, E6, E7, E8, E9,
    inout        E10, E11, E12, E13, E14, E15, E16, E17, E18, E19,
    inout        E20, E21, E22, E23, E24, E25, E26, E27, E28, E29,
    inout        E30, E31, 
    // More extended connection to Castle-ated vias
    inout        G0, G1,
    
    // Standard Feather D pins, Passed through the FPGA
    inout        D0, D1, D4, D5, D6, D8, D9,
    inout        D10, // Also JTAG 
    inout        D11, // Also JTAG 
    inout        D12, // Also JTAG 
    inout        D13, // Also JTAG 
    output logic D13_LED, // always reflects state of D13
    
    // Standard Feather D pins, sent from SAMD
    inout        FPGA_D0, FPGA_D1, FPGA_D4, FPGA_D5, FPGA_D6, FPGA_D8, FPGA_D9,
    inout        FPGA_D10,
    inout        FPGA_D11,
    inout        FPGA_D12,
    inout        FPGA_D13,
    
    // SPI bus, from SAMD to be passed through FPGA
    inout        FPGA_MISO,
    inout        FPGA_MOSI,
    inout        FPGA_SCK,
    
    // Dedicated I2C bus between SAMD and FPGA
    inout        FPGA_SCL,
    inout        FPGA_SDA,
    
    // If HIGH, D[13:10] are JTAG pins
    input        JTAGEN,
    
    // SPI bus passed through the FPGA
    inout        MISO,
    inout        MOSI,
    inout        SCK
    );
   

   always_comb D13_LED = D13;
   
   //======================================================================
   // Instance Name:  evo_core_inst
   // Module Type:    evo_core
   //----------------------------------------------------------------------
   // Everything lives in the core except the top level pins
   //
   //======================================================================

`ifdef PCC_FIXME
  evo_core_pcc
`else
   evo_core
`endif
     
     #(.DC_COMPACT          (DC_COMPACT),
       .DC_FPGA_SIZE        (DC_FPGA_SIZE),
       .FLASH_BYTE_FLIP     (FLASH_BYTE_FLIP), // Flip the bits going to xlr8_flashload
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
   evo_core_inst
     (// CLocks and Resets
      .FPGA_CLK   (FPGA_CLK),
      .FPGA_CLKEN (FPGA_CLKEN),
      .RESETN     (RESETN),
      
      // Dedicated bus between SAMD and FPGA
      .Z0  (Z0),
      .Z1  (Z1),
      .Z2  (Z2),
      .Z3  (Z3),
      .Z4  (Z4),
      .Z5  (Z5),
      .Z6  (Z6),
      .Z7  (Z7),
      .Z8  (Z8),
      .Z9  (Z9),
      
      // Extended connection so Castle-ated vias
      .E0  (E0),
      .E1  (E1),
      .E2  (E2),
      .E3  (E3),
      .E4  (E4),
      .E5  (E5),
      .E6  (E6),
      .E7  (E7),
      .E8  (E8),
      .E9  (E9),
      .E10 (E10),
      .E11 (E11),
      .E12 (E12),
      .E13 (E13),
      .E14 (E14),
      .E15 (E15),
      .E16 (E16),
      .E17 (E17),
      .E18 (E18),
      .E19 (E19),
      .E20 (E20),
      .E21 (E21),
      .E22 (E22),
      .E23 (E23),
      .E24 (E24),
      .E25 (E25),
      .E26 (E26),
      .E27 (E27),
      .E28 (E28),
      .E29 (E29),
      .E30 (E30),
      .E31 (E31),
      // Port G is also Castle-ated vias
      .G0 (G0),
      .G1 (G1),
      
      // Standard Feather D pins, Passed through the FPGA
      .D0  (D0),
      .D1  (D1),
      .D4  (D4),
      .D5  (D5),
      .D6  (D6),
      .D8  (D8),
      .D9  (D9),
      .D10 (D10), // Also JTAG 
      .D11 (D11), // Also JTAG 
      .D12 (D12), // Also JTAG 
      .D13 (D13), // Also JTAG 
      
      // Standard Feather D pins, sent from SAMD
      .FPGA_D0   (FPGA_D0),
      .FPGA_D1   (FPGA_D1),
      .FPGA_D4   (FPGA_D4),
      .FPGA_D5   (FPGA_D5),
      .FPGA_D6   (FPGA_D6),
      .FPGA_D8   (FPGA_D8),
      .FPGA_D9   (FPGA_D9),
      .FPGA_D10  (FPGA_D10),
      .FPGA_D11  (FPGA_D11),
      .FPGA_D12  (FPGA_D12),
      .FPGA_D13  (FPGA_D13),
      
      // SPI bus, from SAMD to be passed through FPGA
      .FPGA_MISO (FPGA_MISO),
      .FPGA_MOSI (FPGA_MOSI),
      .FPGA_SCK  (FPGA_SCK),
      
      // Dedicated I2C bus between SAMD and FPGA
      .FPGA_SCL  (FPGA_SCL),
      .FPGA_SDA  (FPGA_SDA),
      
      // If HIGH, D[13:10] are JTAG pins
      .JTAGEN    (JTAGEN),
      
      // SPI bus passed through the FPGA
      .MISO      (MISO),
      .MOSI      (MOSI),
      .SCK       (SCK)
      );
   
   
endmodule
