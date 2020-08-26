//===========================================================================
//  Copyright(c) Alorium Technology Group Inc., 2019
//  ALL RIGHTS RESERVED
//===========================================================================
//
// File name:  : evo_addr_pkg.sv
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description : 
// 
//   This file defines all the address parameters used in the
//   design. Most are for the CSR Avalon bus, but some addresses are
//   used on private DBUS interfaces between XLR8 IP blocks and the
//   wrapper around them.
//
//   These addresses are avaialable for use in all modules of the design.
//
//===========================================================================

`ifndef _EVO_ADDR_PKG_DONE 
`define _EVO_ADDR_PKG_DONE      // set flag that pkg already included 


package evo_addr_pkg; 
   //==============================================================================
   // Private (non-CSR) Address definitions
   //==============================================================================

   //------------------------------------------------------------------------------
   // I2C DBUS
   //
   // These are used only between the evo_i2c_ctrl and the
   // evo_i2c_ip. The addresses are not in the same namespace as any
   // other addresses
   parameter I2C_TWCR_ADDR  = 8'hE0;
   parameter I2C_TWDR_ADDR  = 8'hE1;
   parameter I2C_TWAR_ADDR  = 8'hE2;
   parameter I2C_TWSR_ADDR  = 8'hE3;
   parameter I2C_TWBR_ADDR  = 8'hE4;
   parameter I2C_TWAMR_ADDR = 8'hE5;

   //------------------------------------------------------------------------------
   // Flashload DBUS
   //    
   // These are used to communicate between the evo_flash_ctrl and the 
   // xlr8_flashload
   parameter FCFG_CID_ADDR  = 8'hCF; // XLR8 flash config: chip id (64b FIFO)
   parameter FCFG_CTL_ADDR  = 8'hD0; // XLR8 flash config: flash programming
   parameter FCFG_STS_ADDR  = 8'hD1; // XLR8 flash config: status
   parameter FCFG_DAT_ADDR  = 8'hD2; // XLR8 flash config: flash programming data

   //------------------------------------------------------------------------------
   // INFO Indirect Addresses
   //
   // Private addresses to do indirect addressing to the EVO_INFO
   // data. The description of the values at these addresses are shown
   // below. The values are defined by module instantiation parameters
   // that are ultimately defined by the evo_info.qsf file, which is
   // created by the qcompile script. Once the evo_bsp QXP is created
   // the corresponding evo_info.qsf file must be included with it in
   // the evo_bsp XB library so that the values match with what is
   // inside the evo_bsp QXP.
   //
   // NAME   Description          Type    Default  Valid Values  
   // ------------------------------------------------------------------------------   
   // MODEL  Alorium Board name   [%4s]   EM51     EM51 (so far)
   // SERIAL Not currently used   [ %d]   1        any  
   // PART   Board Date           [ %d]   202002   201910,202002 (so far) 
   // FTYPE  FPGA Type            [%4s]   10M      10M
   // FSIZE  FPGA Size            [ %d]   25       02,04,08,16,25,40,50
   // FSPLY  FPGA Supply          [%1s]   D        S,D
   // FFEAT  FPGA Feature Option  [%1s]   A        A,C,D,F
   // FPACK  FPGA Package Type    [%1s]   F        E,F,M,U,V
   // FPINS  FPGA Pin Count       [ %d]   256      36,81,144,153,169,256,324,484,672
   // FTEMP  FPGA Operating Temp  [%1s]   C        A,C,I
   // FSPED  FPGA Speed           [ %d]   8        6,7,8
   // FOPTN  FPGA Optional Suffix [%1s]   G        E,G,P
   // VER    Release Version      [ %d]   1        any   
   // SVN    SVN Repo Version     [ %d]   273      any   
   parameter EVO_INFO_MODEL_ADDR   = 32'h0;
   parameter EVO_INFO_SERIAL_ADDR  = 32'h1;
   parameter EVO_INFO_PART_ADDR    = 32'h2;
   parameter EVO_INFO_FTYPE_ADDR   = 32'h10;
   parameter EVO_INFO_FSIZE_ADDR   = 32'h11;
   parameter EVO_INFO_FSPLY_ADDR   = 32'h12;
   parameter EVO_INFO_FFEAT_ADDR   = 32'h13;
   parameter EVO_INFO_FPACK_ADDR   = 32'h14;
   parameter EVO_INFO_FPINS_ADDR   = 32'h15;
   parameter EVO_INFO_FTEMP_ADDR   = 32'h16;
   parameter EVO_INFO_FSPED_ADDR   = 32'h17;
   parameter EVO_INFO_FOPTN_ADDR   = 32'h18;
   parameter EVO_INFO_VER_ADDR     = 32'h20;
   parameter EVO_INFO_SVN_ADDR     = 32'h21;

   //------------------------------------------------------------------------------
   // XB INFO Indirect Addresses
   //
   // Private addresses used to do indirect addressing in the
   // evo_xb_info module. This is a seperate INFO module in the evo_xb
   // that allows the user to specify thier own INFO CSRs. There are
   // four standard CSRs included in all evo_xb_info modules
   parameter EVO_XB_INFO_NUM_ADDR    = 32'h0; // Address of XB_INFO_NUM value
   parameter EVO_XB_INFO_VENDOR_ADDR = 32'h1; // Address and Value for Vendor name
   parameter EVO_XB_INFO_MODEL_ADDR  = 32'h2; // Address and Value for product Model 
   parameter EVO_XB_INFO_TYPE_ADDR   = 32'h3; // Address and Value for XB Type
   
   //==============================================================================
   //==============================================================================
   //
   //   Start of EVO CSR Reg Address Space
   //
   //==============================================================================
   //==============================================================================

   //==============================================================================
   // EVO XB Info Registers
   //------------------------------------------------------------------------------
   // This is the only address outside of the BSP address space (0x7ff-0x000). 
   // Listing it here so it dowsn't go unoticed way at the end of this file.
   parameter EVO_XB_INFO_ADDR   = 12'h801; // Evo Info Reg

   //==============================================================================
   // EVO I2C Control Registers
   //------------------------------------------------------------------------------
   parameter REG_H000        = 12'h000; // Placeholder for CSR Reg 
   parameter EVO_INFO_ADDR   = 12'h001; // Evo Info Reg
   // parameter I2C             = 12'h002;
   // parameter                 = 12'h003;
   // parameter                 = 12'h004;
   // parameter                 = 12'h005;
   // parameter                 = 12'h006;
   // parameter                 = 12'h007;
   parameter EVO_TWCR_ADDR   = 12'h008;
   parameter EVO_TWDR_ADDR   = 12'h009;
   parameter EVO_TWAR_ADDR   = 12'h00A;
   parameter EVO_TWSR_ADDR   = 12'h00B;
   parameter EVO_TWBR_ADDR   = 12'h00C;
   parameter EVO_TWAMR_ADDR  = 12'h00D;
   parameter REG_H00E        = 12'h00E; // In evo_i2c_reg
   parameter REG_H00F        = 12'h00F; // In evo_i2c_reg
   // parameter                 = 12'h00F;

   //==============================================================================
   // Evo D2F CSR Registers
   //------------------------------------------------------------------------------
   parameter D2F_BASE_ADDR   = 12'h010; // D2F Module Base Address
   parameter D2F_DIR_ADDR    = D2F_BASE_ADDR + 12'h000; // Direction CSR for D2F
   parameter D2F_DIRCLR_ADDR = D2F_BASE_ADDR + 12'h001; // Direction CLR CSR for D2F
   parameter D2F_DIRSET_ADDR = D2F_BASE_ADDR + 12'h002; // Direction SET CSR for D2F
   parameter D2F_DIRTGL_ADDR = D2F_BASE_ADDR + 12'h003; // Direction TGL CSR for D2F
   parameter D2F_EN_ADDR     = D2F_BASE_ADDR + 12'h004; // Enable CSR for D2F
   parameter D2F_ENCLR_ADDR  = D2F_BASE_ADDR + 12'h005; // Enable CLR CSR for D2F
   parameter D2F_ENSET_ADDR  = D2F_BASE_ADDR + 12'h006; // Enable SET CSR for D2F
   parameter D2F_ENTGL_ADDR  = D2F_BASE_ADDR + 12'h007; // Enable TGL CSR for D2F

   //==============================================================================
   // Evo Flash CSR Registers
   //------------------------------------------------------------------------------
   parameter FLASH_BASE_ADDR      = 12'h040; // Evo Flash Control Base Address
   parameter FLASH_STS_ADDR       = FLASH_BASE_ADDR + 12'h000; // Status Reg
   parameter FLASH_CTL_ADDR       = FLASH_BASE_ADDR + 12'h001; // Control Reg
   parameter FLASH_CRC_ADDR       = FLASH_BASE_ADDR + 12'h002; // CRC Reg
   parameter FLASH_IMG_ADDR       = FLASH_BASE_ADDR + 12'h003; // Image Reg
   parameter FLASH_DBG_ADDR       = FLASH_BASE_ADDR + 12'h004; // Debug reg
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h005; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h006; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h007; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h008; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h009; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h00A; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h00B; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h00C; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h00D; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h00E; // - unused -
   // parameter FLASH_unused         = FLASH_BASE_ADDR + 12'h00F; // - unused -
   //==============================================================================
   // Flashload APAGE Buffer - 128 bytes (32 words x 4 bytes/word)
   //------------------------------------------------------------------------------
   parameter FLASH_APAGE_ADDR     = FLASH_BASE_ADDR  + 12'h010; // Flash APAGE buffer starting address
   parameter FLASH_APAGE_00_ADDR  = FLASH_APAGE_ADDR + 12'h000; // APAGE buffer word 0
   parameter FLASH_APAGE_01_ADDR  = FLASH_APAGE_ADDR + 12'h001; // APAGE buffer word 1
   parameter FLASH_APAGE_02_ADDR  = FLASH_APAGE_ADDR + 12'h002; // APAGE buffer word 2
   parameter FLASH_APAGE_03_ADDR  = FLASH_APAGE_ADDR + 12'h003; // APAGE buffer word 3
   parameter FLASH_APAGE_04_ADDR  = FLASH_APAGE_ADDR + 12'h004; // APAGE buffer word 4
   parameter FLASH_APAGE_05_ADDR  = FLASH_APAGE_ADDR + 12'h005; // APAGE buffer word 5
   parameter FLASH_APAGE_06_ADDR  = FLASH_APAGE_ADDR + 12'h006; // APAGE buffer word 6
   parameter FLASH_APAGE_07_ADDR  = FLASH_APAGE_ADDR + 12'h007; // APAGE buffer word 7
   parameter FLASH_APAGE_08_ADDR  = FLASH_APAGE_ADDR + 12'h008; // APAGE buffer word 8
   parameter FLASH_APAGE_09_ADDR  = FLASH_APAGE_ADDR + 12'h009; // APAGE buffer word 9
   parameter FLASH_APAGE_10_ADDR  = FLASH_APAGE_ADDR + 12'h00A; // APAGE buffer word 10
   parameter FLASH_APAGE_11_ADDR  = FLASH_APAGE_ADDR + 12'h00B; // APAGE buffer word 11
   parameter FLASH_APAGE_12_ADDR  = FLASH_APAGE_ADDR + 12'h00C; // APAGE buffer word 12
   parameter FLASH_APAGE_13_ADDR  = FLASH_APAGE_ADDR + 12'h00D; // APAGE buffer word 13
   parameter FLASH_APAGE_14_ADDR  = FLASH_APAGE_ADDR + 12'h00E; // APAGE buffer word 14
   parameter FLASH_APAGE_15_ADDR  = FLASH_APAGE_ADDR + 12'h00F; // APAGE buffer word 15
   parameter FLASH_APAGE_16_ADDR  = FLASH_APAGE_ADDR + 12'h010; // APAGE buffer word 16
   parameter FLASH_APAGE_17_ADDR  = FLASH_APAGE_ADDR + 12'h011; // APAGE buffer word 17
   parameter FLASH_APAGE_18_ADDR  = FLASH_APAGE_ADDR + 12'h012; // APAGE buffer word 18
   parameter FLASH_APAGE_19_ADDR  = FLASH_APAGE_ADDR + 12'h013; // APAGE buffer word 19
   parameter FLASH_APAGE_20_ADDR  = FLASH_APAGE_ADDR + 12'h014; // APAGE buffer word 20
   parameter FLASH_APAGE_21_ADDR  = FLASH_APAGE_ADDR + 12'h015; // APAGE buffer word 21
   parameter FLASH_APAGE_22_ADDR  = FLASH_APAGE_ADDR + 12'h016; // APAGE buffer word 22
   parameter FLASH_APAGE_23_ADDR  = FLASH_APAGE_ADDR + 12'h017; // APAGE buffer word 23
   parameter FLASH_APAGE_24_ADDR  = FLASH_APAGE_ADDR + 12'h018; // APAGE buffer word 24
   parameter FLASH_APAGE_25_ADDR  = FLASH_APAGE_ADDR + 12'h019; // APAGE buffer word 25
   parameter FLASH_APAGE_26_ADDR  = FLASH_APAGE_ADDR + 12'h01A; // APAGE buffer word 26
   parameter FLASH_APAGE_27_ADDR  = FLASH_APAGE_ADDR + 12'h01B; // APAGE buffer word 27
   parameter FLASH_APAGE_28_ADDR  = FLASH_APAGE_ADDR + 12'h01C; // APAGE buffer word 28
   parameter FLASH_APAGE_29_ADDR  = FLASH_APAGE_ADDR + 12'h01D; // APAGE buffer word 29
   parameter FLASH_APAGE_30_ADDR  = FLASH_APAGE_ADDR + 12'h01E; // APAGE buffer word 30
   parameter FLASH_APAGE_31_ADDR  = FLASH_APAGE_ADDR + 12'h01F; // APAGE buffer word 31

   //==============================================================================
   // FPGA Port D Control Registers
   //------------------------------------------------------------------------------
   parameter PORT_D_BASE_ADDR      = 12'h080; // FPGA Port D Base Address
   parameter PORT_D_DIR_ADDR       = PORT_D_BASE_ADDR + 12'h000; // Data Direction Reg
   parameter PORT_D_DIRCLR_ADDR    = PORT_D_BASE_ADDR + 12'h001; // Data Direction Clear Reg
   parameter PORT_D_DIRSET_ADDR    = PORT_D_BASE_ADDR + 12'h002; // Data Direction Set Reg
   parameter PORT_D_DIRTGL_ADDR    = PORT_D_BASE_ADDR + 12'h003; // Data Direction Toggle Reg
   parameter PORT_D_OUT_ADDR       = PORT_D_BASE_ADDR + 12'h004; // Data Output Value Reg
   parameter PORT_D_OUTCLR_ADDR    = PORT_D_BASE_ADDR + 12'h005; // Data Output Clear Reg
   parameter PORT_D_OUTSET_ADDR    = PORT_D_BASE_ADDR + 12'h006; // Data Output Set Reg
   parameter PORT_D_OUTTGL_ADDR    = PORT_D_BASE_ADDR + 12'h007; // Data Output Toggle reg
   parameter PORT_D_IN_ADDR        = PORT_D_BASE_ADDR + 12'h008; // Data Input Value
   parameter PORT_D_CTRL_ADDR      = PORT_D_BASE_ADDR + 12'h009; // Control reg
   parameter PORT_D_WRCONFIG_ADDR  = PORT_D_BASE_ADDR + 12'h00A; // Write Configuration Reg
   parameter PORT_D_EVCTRL_ADDR    = PORT_D_BASE_ADDR + 12'h00B; // Event Control Reg
   parameter PORT_D_PMUXEN_ADDR    = PORT_D_BASE_ADDR + 12'h00C; // Parallel R/W of PMUXEN bits
   parameter PORT_D_PMUXENCLR_ADDR = PORT_D_BASE_ADDR + 12'h00D; // Parallel Clear of PMUXEN bits
   parameter PORT_D_PMUXENSET_ADDR = PORT_D_BASE_ADDR + 12'h00E; // Parallel Set of PMUXEN bits
   parameter PORT_D_PMUXENTGL_ADDR = PORT_D_BASE_ADDR + 12'h00F; // Parallel ToggleR/W of PMUXEN bits
   parameter PORT_D_PINMUX00_ADDR  = PORT_D_BASE_ADDR + 12'h010; // Peripheral Multiplexing Bits [01:00]
   parameter PORT_D_PINMUX01_ADDR  = PORT_D_BASE_ADDR + 12'h011; // Peripheral Multiplexing Bits [03:02]
   parameter PORT_D_PINMUX02_ADDR  = PORT_D_BASE_ADDR + 12'h012; // Peripheral Multiplexing Bits [05:04]
   parameter PORT_D_PINMUX03_ADDR  = PORT_D_BASE_ADDR + 12'h013; // Peripheral Multiplexing Bits [07:06]
   parameter PORT_D_PINMUX04_ADDR  = PORT_D_BASE_ADDR + 12'h014; // Peripheral Multiplexing Bits [09:08]
   parameter PORT_D_PINMUX05_ADDR  = PORT_D_BASE_ADDR + 12'h015; // Peripheral Multiplexing Bits [11:10]
   parameter PORT_D_PINMUX06_ADDR  = PORT_D_BASE_ADDR + 12'h016; // Peripheral Multiplexing Bits [13:12]
   parameter PORT_D_PINMUX07_ADDR  = PORT_D_BASE_ADDR + 12'h017; // Peripheral Multiplexing Bits [15:14]
   parameter PORT_D_PINMUX08_ADDR  = PORT_D_BASE_ADDR + 12'h018; // Peripheral Multiplexing Bits [17:16]
   parameter PORT_D_PINMUX09_ADDR  = PORT_D_BASE_ADDR + 12'h019; // Peripheral Multiplexing Bits [19:18]
   parameter PORT_D_PINMUX10_ADDR  = PORT_D_BASE_ADDR + 12'h01A; // Peripheral Multiplexing Bits [21:20]
   parameter PORT_D_PINMUX11_ADDR  = PORT_D_BASE_ADDR + 12'h01B; // Peripheral Multiplexing Bits [23:22]
   parameter PORT_D_PINMUX12_ADDR  = PORT_D_BASE_ADDR + 12'h01C; // Peripheral Multiplexing Bits [25:24]
   parameter PORT_D_PINMUX13_ADDR  = PORT_D_BASE_ADDR + 12'h01D; // Peripheral Multiplexing Bits [27:26]
   parameter PORT_D_PINMUX14_ADDR  = PORT_D_BASE_ADDR + 12'h01E; // Peripheral Multiplexing Bits [29:28]
   parameter PORT_D_PINMUX15_ADDR  = PORT_D_BASE_ADDR + 12'h01F; // Peripheral Multiplexing Bits [31:30]
   parameter PORT_D_PINCFG00_ADDR  = PORT_D_BASE_ADDR + 12'h020; // Pin Configuration Bit 00
   parameter PORT_D_PINCFG01_ADDR  = PORT_D_BASE_ADDR + 12'h021; // Pin Configuration Bit 01 
   parameter PORT_D_PINCFG02_ADDR  = PORT_D_BASE_ADDR + 12'h022; // Pin Configuration Bit 02 
   parameter PORT_D_PINCFG03_ADDR  = PORT_D_BASE_ADDR + 12'h023; // Pin Configuration Bit 03 
   parameter PORT_D_PINCFG04_ADDR  = PORT_D_BASE_ADDR + 12'h024; // Pin Configuration Bit 04 
   parameter PORT_D_PINCFG05_ADDR  = PORT_D_BASE_ADDR + 12'h025; // Pin Configuration Bit 05 
   parameter PORT_D_PINCFG06_ADDR  = PORT_D_BASE_ADDR + 12'h026; // Pin Configuration Bit 06 
   parameter PORT_D_PINCFG07_ADDR  = PORT_D_BASE_ADDR + 12'h027; // Pin Configuration Bit 07 
   parameter PORT_D_PINCFG08_ADDR  = PORT_D_BASE_ADDR + 12'h028; // Pin Configuration Bit 08 
   parameter PORT_D_PINCFG09_ADDR  = PORT_D_BASE_ADDR + 12'h029; // Pin Configuration Bit 09 
   parameter PORT_D_PINCFG10_ADDR  = PORT_D_BASE_ADDR + 12'h02A; // Pin Configuration Bit 10 
   parameter PORT_D_PINCFG11_ADDR  = PORT_D_BASE_ADDR + 12'h02B; // Pin Configuration Bit 11 
   parameter PORT_D_PINCFG12_ADDR  = PORT_D_BASE_ADDR + 12'h02C; // Pin Configuration Bit 12 
   parameter PORT_D_PINCFG13_ADDR  = PORT_D_BASE_ADDR + 12'h02D; // Pin Configuration Bit 13 
   parameter PORT_D_PINCFG14_ADDR  = PORT_D_BASE_ADDR + 12'h02E; // Pin Configuration Bit 14 
   parameter PORT_D_PINCFG15_ADDR  = PORT_D_BASE_ADDR + 12'h02F; // Pin Configuration Bit 15 
   parameter PORT_D_PINCFG16_ADDR  = PORT_D_BASE_ADDR + 12'h030; // Pin Configuration Bit 16 
   parameter PORT_D_PINCFG17_ADDR  = PORT_D_BASE_ADDR + 12'h031; // Pin Configuration Bit 17 
   parameter PORT_D_PINCFG18_ADDR  = PORT_D_BASE_ADDR + 12'h032; // Pin Configuration Bit 18 
   parameter PORT_D_PINCFG19_ADDR  = PORT_D_BASE_ADDR + 12'h033; // Pin Configuration Bit 19 
   parameter PORT_D_PINCFG20_ADDR  = PORT_D_BASE_ADDR + 12'h034; // Pin Configuration Bit 20 
   parameter PORT_D_PINCFG21_ADDR  = PORT_D_BASE_ADDR + 12'h035; // Pin Configuration Bit 21 
   parameter PORT_D_PINCFG22_ADDR  = PORT_D_BASE_ADDR + 12'h036; // Pin Configuration Bit 22 
   parameter PORT_D_PINCFG23_ADDR  = PORT_D_BASE_ADDR + 12'h037; // Pin Configuration Bit 23 
   parameter PORT_D_PINCFG24_ADDR  = PORT_D_BASE_ADDR + 12'h038; // Pin Configuration Bit 24 
   parameter PORT_D_PINCFG25_ADDR  = PORT_D_BASE_ADDR + 12'h039; // Pin Configuration Bit 25 
   parameter PORT_D_PINCFG26_ADDR  = PORT_D_BASE_ADDR + 12'h03A; // Pin Configuration Bit 26 
   parameter PORT_D_PINCFG27_ADDR  = PORT_D_BASE_ADDR + 12'h03B; // Pin Configuration Bit 27 
   parameter PORT_D_PINCFG28_ADDR  = PORT_D_BASE_ADDR + 12'h03C; // Pin Configuration Bit 28 
   parameter PORT_D_PINCFG29_ADDR  = PORT_D_BASE_ADDR + 12'h03D; // Pin Configuration Bit 29 
   parameter PORT_D_PINCFG30_ADDR  = PORT_D_BASE_ADDR + 12'h03E; // Pin Configuration Bit 30 
   parameter PORT_D_PINCFG31_ADDR  = PORT_D_BASE_ADDR + 12'h03F; // Pin Configuration Bit 31 

   //==============================================================================
   // FPGA Port E Control Registers
   //------------------------------------------------------------------------------
   parameter PORT_E_BASE_ADDR      = 12'h0C0; // FPGA Port E Base Address
   parameter PORT_E_DIR_ADDR       = PORT_E_BASE_ADDR + 12'h000; // Data Direction Reg
   parameter PORT_E_DIRCLR_ADDR    = PORT_E_BASE_ADDR + 12'h001; // Data Direction Clear Reg
   parameter PORT_E_DIRSET_ADDR    = PORT_E_BASE_ADDR + 12'h002; // Data Direction Set Reg
   parameter PORT_E_DIRTGL_ADDR    = PORT_E_BASE_ADDR + 12'h003; // Data Direction Toggle Reg
   parameter PORT_E_OUT_ADDR       = PORT_E_BASE_ADDR + 12'h004; // Data Output Value Reg
   parameter PORT_E_OUTCLR_ADDR    = PORT_E_BASE_ADDR + 12'h005; // Data Output Clear Reg
   parameter PORT_E_OUTSET_ADDR    = PORT_E_BASE_ADDR + 12'h006; // Data Output Set Reg
   parameter PORT_E_OUTTGL_ADDR    = PORT_E_BASE_ADDR + 12'h007; // Data Output Toggle reg
   parameter PORT_E_IN_ADDR        = PORT_E_BASE_ADDR + 12'h008; // Data Input Value
   parameter PORT_E_CTRL_ADDR      = PORT_E_BASE_ADDR + 12'h009; // Control reg
   parameter PORT_E_WRCONFIG_ADDR  = PORT_E_BASE_ADDR + 12'h00A; // Write Configuration Reg
   parameter PORT_E_EVCTRL_ADDR    = PORT_E_BASE_ADDR + 12'h00B; // Event Control Reg
   parameter PORT_E_PMUXEN_ADDR    = PORT_E_BASE_ADDR + 12'h00C; // Parallel R/W of PMUXEN bits
   parameter PORT_E_PMUXENCLR_ADDR = PORT_E_BASE_ADDR + 12'h00D; // Parallel Clear of PMUXEN bits
   parameter PORT_E_PMUXENSET_ADDR = PORT_E_BASE_ADDR + 12'h00E; // Parallel Set of PMUXEN bits
   parameter PORT_E_PMUXENTGL_ADDR = PORT_E_BASE_ADDR + 12'h00F; // Parallel ToggleR/W of PMUXEN bits
   parameter PORT_E_PINMUX00_ADDR  = PORT_E_BASE_ADDR + 12'h010; // Peripheral Multiplexing Bits [01:00]
   parameter PORT_E_PINMUX01_ADDR  = PORT_E_BASE_ADDR + 12'h011; // Peripheral Multiplexing Bits [03:02]
   parameter PORT_E_PINMUX02_ADDR  = PORT_E_BASE_ADDR + 12'h012; // Peripheral Multiplexing Bits [05:04]
   parameter PORT_E_PINMUX03_ADDR  = PORT_E_BASE_ADDR + 12'h013; // Peripheral Multiplexing Bits [07:06]
   parameter PORT_E_PINMUX04_ADDR  = PORT_E_BASE_ADDR + 12'h014; // Peripheral Multiplexing Bits [09:08]
   parameter PORT_E_PINMUX05_ADDR  = PORT_E_BASE_ADDR + 12'h015; // Peripheral Multiplexing Bits [11:10]
   parameter PORT_E_PINMUX06_ADDR  = PORT_E_BASE_ADDR + 12'h016; // Peripheral Multiplexing Bits [13:12]
   parameter PORT_E_PINMUX07_ADDR  = PORT_E_BASE_ADDR + 12'h017; // Peripheral Multiplexing Bits [15:14]
   parameter PORT_E_PINMUX08_ADDR  = PORT_E_BASE_ADDR + 12'h018; // Peripheral Multiplexing Bits [17:16]
   parameter PORT_E_PINMUX09_ADDR  = PORT_E_BASE_ADDR + 12'h019; // Peripheral Multiplexing Bits [19:18]
   parameter PORT_E_PINMUX10_ADDR  = PORT_E_BASE_ADDR + 12'h01A; // Peripheral Multiplexing Bits [21:20]
   parameter PORT_E_PINMUX11_ADDR  = PORT_E_BASE_ADDR + 12'h01B; // Peripheral Multiplexing Bits [23:22]
   parameter PORT_E_PINMUX12_ADDR  = PORT_E_BASE_ADDR + 12'h01C; // Peripheral Multiplexing Bits [25:24]
   parameter PORT_E_PINMUX13_ADDR  = PORT_E_BASE_ADDR + 12'h01D; // Peripheral Multiplexing Bits [27:26]
   parameter PORT_E_PINMUX14_ADDR  = PORT_E_BASE_ADDR + 12'h01E; // Peripheral Multiplexing Bits [29:28]
   parameter PORT_E_PINMUX15_ADDR  = PORT_E_BASE_ADDR + 12'h01F; // Peripheral Multiplexing Bits [31:30]
   parameter PORT_E_PINCFG00_ADDR  = PORT_E_BASE_ADDR + 12'h020; // Pin Configuration Bit 00
   parameter PORT_E_PINCFG01_ADDR  = PORT_E_BASE_ADDR + 12'h021; // Pin Configuration Bit 01 
   parameter PORT_E_PINCFG02_ADDR  = PORT_E_BASE_ADDR + 12'h022; // Pin Configuration Bit 02 
   parameter PORT_E_PINCFG03_ADDR  = PORT_E_BASE_ADDR + 12'h023; // Pin Configuration Bit 03 
   parameter PORT_E_PINCFG04_ADDR  = PORT_E_BASE_ADDR + 12'h024; // Pin Configuration Bit 04 
   parameter PORT_E_PINCFG05_ADDR  = PORT_E_BASE_ADDR + 12'h025; // Pin Configuration Bit 05 
   parameter PORT_E_PINCFG06_ADDR  = PORT_E_BASE_ADDR + 12'h026; // Pin Configuration Bit 06 
   parameter PORT_E_PINCFG07_ADDR  = PORT_E_BASE_ADDR + 12'h027; // Pin Configuration Bit 07 
   parameter PORT_E_PINCFG08_ADDR  = PORT_E_BASE_ADDR + 12'h028; // Pin Configuration Bit 08 
   parameter PORT_E_PINCFG09_ADDR  = PORT_E_BASE_ADDR + 12'h029; // Pin Configuration Bit 09 
   parameter PORT_E_PINCFG10_ADDR  = PORT_E_BASE_ADDR + 12'h02A; // Pin Configuration Bit 10 
   parameter PORT_E_PINCFG11_ADDR  = PORT_E_BASE_ADDR + 12'h02B; // Pin Configuration Bit 11 
   parameter PORT_E_PINCFG12_ADDR  = PORT_E_BASE_ADDR + 12'h02C; // Pin Configuration Bit 12 
   parameter PORT_E_PINCFG13_ADDR  = PORT_E_BASE_ADDR + 12'h02D; // Pin Configuration Bit 13 
   parameter PORT_E_PINCFG14_ADDR  = PORT_E_BASE_ADDR + 12'h02E; // Pin Configuration Bit 14 
   parameter PORT_E_PINCFG15_ADDR  = PORT_E_BASE_ADDR + 12'h02F; // Pin Configuration Bit 15 
   parameter PORT_E_PINCFG16_ADDR  = PORT_E_BASE_ADDR + 12'h030; // Pin Configuration Bit 16 
   parameter PORT_E_PINCFG17_ADDR  = PORT_E_BASE_ADDR + 12'h031; // Pin Configuration Bit 17 
   parameter PORT_E_PINCFG18_ADDR  = PORT_E_BASE_ADDR + 12'h032; // Pin Configuration Bit 18 
   parameter PORT_E_PINCFG19_ADDR  = PORT_E_BASE_ADDR + 12'h033; // Pin Configuration Bit 19 
   parameter PORT_E_PINCFG20_ADDR  = PORT_E_BASE_ADDR + 12'h034; // Pin Configuration Bit 20 
   parameter PORT_E_PINCFG21_ADDR  = PORT_E_BASE_ADDR + 12'h035; // Pin Configuration Bit 21 
   parameter PORT_E_PINCFG22_ADDR  = PORT_E_BASE_ADDR + 12'h036; // Pin Configuration Bit 22 
   parameter PORT_E_PINCFG23_ADDR  = PORT_E_BASE_ADDR + 12'h037; // Pin Configuration Bit 23 
   parameter PORT_E_PINCFG24_ADDR  = PORT_E_BASE_ADDR + 12'h038; // Pin Configuration Bit 24 
   parameter PORT_E_PINCFG25_ADDR  = PORT_E_BASE_ADDR + 12'h039; // Pin Configuration Bit 25 
   parameter PORT_E_PINCFG26_ADDR  = PORT_E_BASE_ADDR + 12'h03A; // Pin Configuration Bit 26 
   parameter PORT_E_PINCFG27_ADDR  = PORT_E_BASE_ADDR + 12'h03B; // Pin Configuration Bit 27 
   parameter PORT_E_PINCFG28_ADDR  = PORT_E_BASE_ADDR + 12'h03C; // Pin Configuration Bit 28 
   parameter PORT_E_PINCFG29_ADDR  = PORT_E_BASE_ADDR + 12'h03D; // Pin Configuration Bit 29 
   parameter PORT_E_PINCFG30_ADDR  = PORT_E_BASE_ADDR + 12'h03E; // Pin Configuration Bit 30 
   parameter PORT_E_PINCFG31_ADDR  = PORT_E_BASE_ADDR + 12'h03F; // Pin Configuration Bit 31 

   //==============================================================================
   // FPGA Port F Control Registers
   //------------------------------------------------------------------------------
   parameter PORT_F_BASE_ADDR      = 12'h100; // FPGA Port F Base Address
   parameter PORT_F_DIR_ADDR       = PORT_F_BASE_ADDR + 12'h000; // Data Direction Reg
   parameter PORT_F_DIRCLR_ADDR    = PORT_F_BASE_ADDR + 12'h001; // Data Direction Clear Reg
   parameter PORT_F_DIRSET_ADDR    = PORT_F_BASE_ADDR + 12'h002; // Data Direction Set Reg
   parameter PORT_F_DIRTGL_ADDR    = PORT_F_BASE_ADDR + 12'h003; // Data Direction Toggle Reg
   parameter PORT_F_OUT_ADDR       = PORT_F_BASE_ADDR + 12'h004; // Data Output Value Reg
   parameter PORT_F_OUTCLR_ADDR    = PORT_F_BASE_ADDR + 12'h005; // Data Output Clear Reg
   parameter PORT_F_OUTSET_ADDR    = PORT_F_BASE_ADDR + 12'h006; // Data Output Set Reg
   parameter PORT_F_OUTTGL_ADDR    = PORT_F_BASE_ADDR + 12'h007; // Data Output Toggle reg
   parameter PORT_F_IN_ADDR        = PORT_F_BASE_ADDR + 12'h008; // Data Input Value
   parameter PORT_F_CTRL_ADDR      = PORT_F_BASE_ADDR + 12'h009; // Control reg
   parameter PORT_F_WRCONFIG_ADDR  = PORT_F_BASE_ADDR + 12'h00A; // Write Configuration Reg
   parameter PORT_F_EVCTRL_ADDR    = PORT_F_BASE_ADDR + 12'h00B; // Event Control Reg
   parameter PORT_F_PMUXEN_ADDR    = PORT_F_BASE_ADDR + 12'h00C; // Parallel R/W of PMUXEN bits
   parameter PORT_F_PMUXENCLR_ADDR = PORT_F_BASE_ADDR + 12'h00D; // Parallel Clear of PMUXEN bits
   parameter PORT_F_PMUXENSET_ADDR = PORT_F_BASE_ADDR + 12'h00E; // Parallel Set of PMUXEN bits
   parameter PORT_F_PMUXENTGL_ADDR = PORT_F_BASE_ADDR + 12'h00F; // Parallel ToggleR/W of PMUXEN bits
   parameter PORT_F_PINMUX00_ADDR  = PORT_F_BASE_ADDR + 12'h010; // Peripheral Multiplexing Bits [01:00]
   parameter PORT_F_PINMUX01_ADDR  = PORT_F_BASE_ADDR + 12'h011; // Peripheral Multiplexing Bits [03:02]
   parameter PORT_F_PINMUX02_ADDR  = PORT_F_BASE_ADDR + 12'h012; // Peripheral Multiplexing Bits [05:04]
   parameter PORT_F_PINMUX03_ADDR  = PORT_F_BASE_ADDR + 12'h013; // Peripheral Multiplexing Bits [07:06]
   parameter PORT_F_PINMUX04_ADDR  = PORT_F_BASE_ADDR + 12'h014; // Peripheral Multiplexing Bits [09:08]
   parameter PORT_F_PINMUX05_ADDR  = PORT_F_BASE_ADDR + 12'h015; // Peripheral Multiplexing Bits [11:10]
   parameter PORT_F_PINMUX06_ADDR  = PORT_F_BASE_ADDR + 12'h016; // Peripheral Multiplexing Bits [13:12]
   parameter PORT_F_PINMUX07_ADDR  = PORT_F_BASE_ADDR + 12'h017; // Peripheral Multiplexing Bits [15:14]
   parameter PORT_F_PINMUX08_ADDR  = PORT_F_BASE_ADDR + 12'h018; // Peripheral Multiplexing Bits [17:16]
   parameter PORT_F_PINMUX09_ADDR  = PORT_F_BASE_ADDR + 12'h019; // Peripheral Multiplexing Bits [19:18]
   parameter PORT_F_PINMUX10_ADDR  = PORT_F_BASE_ADDR + 12'h01A; // Peripheral Multiplexing Bits [21:20]
   parameter PORT_F_PINMUX11_ADDR  = PORT_F_BASE_ADDR + 12'h01B; // Peripheral Multiplexing Bits [23:22]
   parameter PORT_F_PINMUX12_ADDR  = PORT_F_BASE_ADDR + 12'h01C; // Peripheral Multiplexing Bits [25:24]
   parameter PORT_F_PINMUX13_ADDR  = PORT_F_BASE_ADDR + 12'h01D; // Peripheral Multiplexing Bits [27:26]
   parameter PORT_F_PINMUX14_ADDR  = PORT_F_BASE_ADDR + 12'h01E; // Peripheral Multiplexing Bits [29:28]
   parameter PORT_F_PINMUX15_ADDR  = PORT_F_BASE_ADDR + 12'h01F; // Peripheral Multiplexing Bits [31:30]
   parameter PORT_F_PINCFG00_ADDR  = PORT_F_BASE_ADDR + 12'h020; // Pin Configuration Bit 00
   parameter PORT_F_PINCFG01_ADDR  = PORT_F_BASE_ADDR + 12'h021; // Pin Configuration Bit 01 
   parameter PORT_F_PINCFG02_ADDR  = PORT_F_BASE_ADDR + 12'h022; // Pin Configuration Bit 02 
   parameter PORT_F_PINCFG03_ADDR  = PORT_F_BASE_ADDR + 12'h023; // Pin Configuration Bit 03 
   parameter PORT_F_PINCFG04_ADDR  = PORT_F_BASE_ADDR + 12'h024; // Pin Configuration Bit 04 
   parameter PORT_F_PINCFG05_ADDR  = PORT_F_BASE_ADDR + 12'h025; // Pin Configuration Bit 05 
   parameter PORT_F_PINCFG06_ADDR  = PORT_F_BASE_ADDR + 12'h026; // Pin Configuration Bit 06 
   parameter PORT_F_PINCFG07_ADDR  = PORT_F_BASE_ADDR + 12'h027; // Pin Configuration Bit 07 
   parameter PORT_F_PINCFG08_ADDR  = PORT_F_BASE_ADDR + 12'h028; // Pin Configuration Bit 08 
   parameter PORT_F_PINCFG09_ADDR  = PORT_F_BASE_ADDR + 12'h029; // Pin Configuration Bit 09 
   parameter PORT_F_PINCFG10_ADDR  = PORT_F_BASE_ADDR + 12'h02A; // Pin Configuration Bit 10 
   parameter PORT_F_PINCFG11_ADDR  = PORT_F_BASE_ADDR + 12'h02B; // Pin Configuration Bit 11 
   parameter PORT_F_PINCFG12_ADDR  = PORT_F_BASE_ADDR + 12'h02C; // Pin Configuration Bit 12 
   parameter PORT_F_PINCFG13_ADDR  = PORT_F_BASE_ADDR + 12'h02D; // Pin Configuration Bit 13 
   parameter PORT_F_PINCFG14_ADDR  = PORT_F_BASE_ADDR + 12'h02E; // Pin Configuration Bit 14 
   parameter PORT_F_PINCFG15_ADDR  = PORT_F_BASE_ADDR + 12'h02F; // Pin Configuration Bit 15 
   parameter PORT_F_PINCFG16_ADDR  = PORT_F_BASE_ADDR + 12'h030; // Pin Configuration Bit 16 
   parameter PORT_F_PINCFG17_ADDR  = PORT_F_BASE_ADDR + 12'h031; // Pin Configuration Bit 17 
   parameter PORT_F_PINCFG18_ADDR  = PORT_F_BASE_ADDR + 12'h032; // Pin Configuration Bit 18 
   parameter PORT_F_PINCFG19_ADDR  = PORT_F_BASE_ADDR + 12'h033; // Pin Configuration Bit 19 
   parameter PORT_F_PINCFG20_ADDR  = PORT_F_BASE_ADDR + 12'h034; // Pin Configuration Bit 20 
   parameter PORT_F_PINCFG21_ADDR  = PORT_F_BASE_ADDR + 12'h035; // Pin Configuration Bit 21 
   parameter PORT_F_PINCFG22_ADDR  = PORT_F_BASE_ADDR + 12'h036; // Pin Configuration Bit 22 
   parameter PORT_F_PINCFG23_ADDR  = PORT_F_BASE_ADDR + 12'h037; // Pin Configuration Bit 23 
   parameter PORT_F_PINCFG24_ADDR  = PORT_F_BASE_ADDR + 12'h038; // Pin Configuration Bit 24 
   parameter PORT_F_PINCFG25_ADDR  = PORT_F_BASE_ADDR + 12'h039; // Pin Configuration Bit 25 
   parameter PORT_F_PINCFG26_ADDR  = PORT_F_BASE_ADDR + 12'h03A; // Pin Configuration Bit 26 
   parameter PORT_F_PINCFG27_ADDR  = PORT_F_BASE_ADDR + 12'h03B; // Pin Configuration Bit 27 
   parameter PORT_F_PINCFG28_ADDR  = PORT_F_BASE_ADDR + 12'h03C; // Pin Configuration Bit 28 
   parameter PORT_F_PINCFG29_ADDR  = PORT_F_BASE_ADDR + 12'h03D; // Pin Configuration Bit 29 
   parameter PORT_F_PINCFG30_ADDR  = PORT_F_BASE_ADDR + 12'h03E; // Pin Configuration Bit 30 
   parameter PORT_F_PINCFG31_ADDR  = PORT_F_BASE_ADDR + 12'h03F; // Pin Configuration Bit 31 

   //==============================================================================
   // FPGA Port G Control Registers
   //------------------------------------------------------------------------------
   parameter PORT_G_BASE_ADDR      = 12'h140; // FPGA Port Z Base Address
   parameter PORT_G_DIR_ADDR       = PORT_G_BASE_ADDR + 12'h000; // Data Direction Reg
   parameter PORT_G_DIRCLR_ADDR    = PORT_G_BASE_ADDR + 12'h001; // Data Direction Clear Reg
   parameter PORT_G_DIRSET_ADDR    = PORT_G_BASE_ADDR + 12'h002; // Data Direction Set Reg
   parameter PORT_G_DIRTGL_ADDR    = PORT_G_BASE_ADDR + 12'h003; // Data Direction Toggle Reg
   parameter PORT_G_OUT_ADDR       = PORT_G_BASE_ADDR + 12'h004; // Data Output Value Reg
   parameter PORT_G_OUTCLR_ADDR    = PORT_G_BASE_ADDR + 12'h005; // Data Output Clear Reg
   parameter PORT_G_OUTSET_ADDR    = PORT_G_BASE_ADDR + 12'h006; // Data Output Set Reg
   parameter PORT_G_OUTTGL_ADDR    = PORT_G_BASE_ADDR + 12'h007; // Data Output Toggle reg
   parameter PORT_G_IN_ADDR        = PORT_G_BASE_ADDR + 12'h008; // Data Input Value
   parameter PORT_G_CTRL_ADDR      = PORT_G_BASE_ADDR + 12'h009; // Control reg
   parameter PORT_G_WRCONFIG_ADDR  = PORT_G_BASE_ADDR + 12'h00A; // Write Configuration Reg
   parameter PORT_G_EVCTRL_ADDR    = PORT_G_BASE_ADDR + 12'h00B; // Event Control Reg
   parameter PORT_G_PMUXEN_ADDR    = PORT_G_BASE_ADDR + 12'h00C; // Parallel R/W of PMUXEN bits
   parameter PORT_G_PMUXENCLR_ADDR = PORT_G_BASE_ADDR + 12'h00D; // Parallel Clear of PMUXEN bits
   parameter PORT_G_PMUXENSET_ADDR = PORT_G_BASE_ADDR + 12'h00E; // Parallel Set of PMUXEN bits
   parameter PORT_G_PMUXENTGL_ADDR = PORT_G_BASE_ADDR + 12'h00F; // Parallel ToggleR/W of PMUXEN bits
   parameter PORT_G_PINMUX00_ADDR  = PORT_G_BASE_ADDR + 12'h010; // Peripheral Multiplexing Bits [01:00]
   parameter PORT_G_PINMUX01_ADDR  = PORT_G_BASE_ADDR + 12'h011; // Peripheral Multiplexing Bits [03:02]
   parameter PORT_G_PINMUX02_ADDR  = PORT_G_BASE_ADDR + 12'h012; // Peripheral Multiplexing Bits [05:04]
   parameter PORT_G_PINMUX03_ADDR  = PORT_G_BASE_ADDR + 12'h013; // Peripheral Multiplexing Bits [07:06]
   parameter PORT_G_PINMUX04_ADDR  = PORT_G_BASE_ADDR + 12'h014; // Peripheral Multiplexing Bits [09:08]
   parameter PORT_G_PINMUX05_ADDR  = PORT_G_BASE_ADDR + 12'h015; // Peripheral Multiplexing Bits [11:10]
   parameter PORT_G_PINMUX06_ADDR  = PORT_G_BASE_ADDR + 12'h016; // Peripheral Multiplexing Bits [13:12]
   parameter PORT_G_PINMUX07_ADDR  = PORT_G_BASE_ADDR + 12'h017; // Peripheral Multiplexing Bits [15:14]
   parameter PORT_G_PINMUX08_ADDR  = PORT_G_BASE_ADDR + 12'h018; // Peripheral Multiplexing Bits [17:16]
   parameter PORT_G_PINMUX09_ADDR  = PORT_G_BASE_ADDR + 12'h019; // Peripheral Multiplexing Bits [19:18]
   parameter PORT_G_PINMUX10_ADDR  = PORT_G_BASE_ADDR + 12'h01A; // Peripheral Multiplexing Bits [21:20]
   parameter PORT_G_PINMUX11_ADDR  = PORT_G_BASE_ADDR + 12'h01B; // Peripheral Multiplexing Bits [23:22]
   parameter PORT_G_PINMUX12_ADDR  = PORT_G_BASE_ADDR + 12'h01C; // Peripheral Multiplexing Bits [25:24]
   parameter PORT_G_PINMUX13_ADDR  = PORT_G_BASE_ADDR + 12'h01D; // Peripheral Multiplexing Bits [27:26]
   parameter PORT_G_PINMUX14_ADDR  = PORT_G_BASE_ADDR + 12'h01E; // Peripheral Multiplexing Bits [29:28]
   parameter PORT_G_PINMUX15_ADDR  = PORT_G_BASE_ADDR + 12'h01F; // Peripheral Multiplexing Bits [31:30]
   parameter PORT_G_PINCFG00_ADDR  = PORT_G_BASE_ADDR + 12'h020; // Pin Configuration Bit 00
   parameter PORT_G_PINCFG01_ADDR  = PORT_G_BASE_ADDR + 12'h021; // Pin Configuration Bit 01 
   parameter PORT_G_PINCFG02_ADDR  = PORT_G_BASE_ADDR + 12'h022; // Pin Configuration Bit 02 
   parameter PORT_G_PINCFG03_ADDR  = PORT_G_BASE_ADDR + 12'h023; // Pin Configuration Bit 03 
   parameter PORT_G_PINCFG04_ADDR  = PORT_G_BASE_ADDR + 12'h024; // Pin Configuration Bit 04 
   parameter PORT_G_PINCFG05_ADDR  = PORT_G_BASE_ADDR + 12'h025; // Pin Configuration Bit 05 
   parameter PORT_G_PINCFG06_ADDR  = PORT_G_BASE_ADDR + 12'h026; // Pin Configuration Bit 06 
   parameter PORT_G_PINCFG07_ADDR  = PORT_G_BASE_ADDR + 12'h027; // Pin Configuration Bit 07 
   parameter PORT_G_PINCFG08_ADDR  = PORT_G_BASE_ADDR + 12'h028; // Pin Configuration Bit 08 
   parameter PORT_G_PINCFG09_ADDR  = PORT_G_BASE_ADDR + 12'h029; // Pin Configuration Bit 09 
   parameter PORT_G_PINCFG10_ADDR  = PORT_G_BASE_ADDR + 12'h02A; // Pin Configuration Bit 10 
   parameter PORT_G_PINCFG11_ADDR  = PORT_G_BASE_ADDR + 12'h02B; // Pin Configuration Bit 11 
   parameter PORT_G_PINCFG12_ADDR  = PORT_G_BASE_ADDR + 12'h02C; // Pin Configuration Bit 12 
   parameter PORT_G_PINCFG13_ADDR  = PORT_G_BASE_ADDR + 12'h02D; // Pin Configuration Bit 13 
   parameter PORT_G_PINCFG14_ADDR  = PORT_G_BASE_ADDR + 12'h02E; // Pin Configuration Bit 14 
   parameter PORT_G_PINCFG15_ADDR  = PORT_G_BASE_ADDR + 12'h02F; // Pin Configuration Bit 15 
   parameter PORT_G_PINCFG16_ADDR  = PORT_G_BASE_ADDR + 12'h030; // Pin Configuration Bit 16 
   parameter PORT_G_PINCFG17_ADDR  = PORT_G_BASE_ADDR + 12'h031; // Pin Configuration Bit 17 
   parameter PORT_G_PINCFG18_ADDR  = PORT_G_BASE_ADDR + 12'h032; // Pin Configuration Bit 18 
   parameter PORT_G_PINCFG19_ADDR  = PORT_G_BASE_ADDR + 12'h033; // Pin Configuration Bit 19 
   parameter PORT_G_PINCFG20_ADDR  = PORT_G_BASE_ADDR + 12'h034; // Pin Configuration Bit 20 
   parameter PORT_G_PINCFG21_ADDR  = PORT_G_BASE_ADDR + 12'h035; // Pin Configuration Bit 21 
   parameter PORT_G_PINCFG22_ADDR  = PORT_G_BASE_ADDR + 12'h036; // Pin Configuration Bit 22 
   parameter PORT_G_PINCFG23_ADDR  = PORT_G_BASE_ADDR + 12'h037; // Pin Configuration Bit 23 
   parameter PORT_G_PINCFG24_ADDR  = PORT_G_BASE_ADDR + 12'h038; // Pin Configuration Bit 24 
   parameter PORT_G_PINCFG25_ADDR  = PORT_G_BASE_ADDR + 12'h039; // Pin Configuration Bit 25 
   parameter PORT_G_PINCFG26_ADDR  = PORT_G_BASE_ADDR + 12'h03A; // Pin Configuration Bit 26 
   parameter PORT_G_PINCFG27_ADDR  = PORT_G_BASE_ADDR + 12'h03B; // Pin Configuration Bit 27 
   parameter PORT_G_PINCFG28_ADDR  = PORT_G_BASE_ADDR + 12'h03C; // Pin Configuration Bit 28 
   parameter PORT_G_PINCFG29_ADDR  = PORT_G_BASE_ADDR + 12'h03D; // Pin Configuration Bit 29 
   parameter PORT_G_PINCFG30_ADDR  = PORT_G_BASE_ADDR + 12'h03E; // Pin Configuration Bit 30 
   parameter PORT_G_PINCFG31_ADDR  = PORT_G_BASE_ADDR + 12'h03F; // Pin Configuration Bit 31 

   //==============================================================================
   // FPGA Port Z Control Registers
   //------------------------------------------------------------------------------
   parameter PORT_Z_BASE_ADDR      = 12'h180; // FPGA Port Z Base Address
   parameter PORT_Z_DIR_ADDR       = PORT_Z_BASE_ADDR + 12'h000; // Data Direction Reg
   parameter PORT_Z_DIRCLR_ADDR    = PORT_Z_BASE_ADDR + 12'h001; // Data Direction Clear Reg
   parameter PORT_Z_DIRSET_ADDR    = PORT_Z_BASE_ADDR + 12'h002; // Data Direction Set Reg
   parameter PORT_Z_DIRTGL_ADDR    = PORT_Z_BASE_ADDR + 12'h003; // Data Direction Toggle Reg
   parameter PORT_Z_OUT_ADDR       = PORT_Z_BASE_ADDR + 12'h004; // Data Output Value Reg
   parameter PORT_Z_OUTCLR_ADDR    = PORT_Z_BASE_ADDR + 12'h005; // Data Output Clear Reg
   parameter PORT_Z_OUTSET_ADDR    = PORT_Z_BASE_ADDR + 12'h006; // Data Output Set Reg
   parameter PORT_Z_OUTTGL_ADDR    = PORT_Z_BASE_ADDR + 12'h007; // Data Output Toggle reg
   parameter PORT_Z_IN_ADDR        = PORT_Z_BASE_ADDR + 12'h008; // Data Input Value
   parameter PORT_Z_CTRL_ADDR      = PORT_Z_BASE_ADDR + 12'h009; // Control reg
   parameter PORT_Z_WRCONFIG_ADDR  = PORT_Z_BASE_ADDR + 12'h00A; // Write Configuration Reg
   parameter PORT_Z_EVCTRL_ADDR    = PORT_Z_BASE_ADDR + 12'h00B; // Event Control Reg
   parameter PORT_Z_PMUXEN_ADDR    = PORT_Z_BASE_ADDR + 12'h00C; // Parallel R/W of PMUXEN bits
   parameter PORT_Z_PMUXENCLR_ADDR = PORT_Z_BASE_ADDR + 12'h00D; // Parallel Clear of PMUXEN bits
   parameter PORT_Z_PMUXENSET_ADDR = PORT_Z_BASE_ADDR + 12'h00E; // Parallel Set of PMUXEN bits
   parameter PORT_Z_PMUXENTGL_ADDR = PORT_Z_BASE_ADDR + 12'h00F; // Parallel ToggleR/W of PMUXEN bits
   parameter PORT_Z_PINMUX00_ADDR  = PORT_Z_BASE_ADDR + 12'h010; // Peripheral Multiplexing Bits [01:00]
   parameter PORT_Z_PINMUX01_ADDR  = PORT_Z_BASE_ADDR + 12'h011; // Peripheral Multiplexing Bits [03:02]
   parameter PORT_Z_PINMUX02_ADDR  = PORT_Z_BASE_ADDR + 12'h012; // Peripheral Multiplexing Bits [05:04]
   parameter PORT_Z_PINMUX03_ADDR  = PORT_Z_BASE_ADDR + 12'h013; // Peripheral Multiplexing Bits [07:06]
   parameter PORT_Z_PINMUX04_ADDR  = PORT_Z_BASE_ADDR + 12'h014; // Peripheral Multiplexing Bits [09:08]
   parameter PORT_Z_PINMUX05_ADDR  = PORT_Z_BASE_ADDR + 12'h015; // Peripheral Multiplexing Bits [11:10]
   parameter PORT_Z_PINMUX06_ADDR  = PORT_Z_BASE_ADDR + 12'h016; // Peripheral Multiplexing Bits [13:12]
   parameter PORT_Z_PINMUX07_ADDR  = PORT_Z_BASE_ADDR + 12'h017; // Peripheral Multiplexing Bits [15:14]
   parameter PORT_Z_PINMUX08_ADDR  = PORT_Z_BASE_ADDR + 12'h018; // Peripheral Multiplexing Bits [17:16]
   parameter PORT_Z_PINMUX09_ADDR  = PORT_Z_BASE_ADDR + 12'h019; // Peripheral Multiplexing Bits [19:18]
   parameter PORT_Z_PINMUX10_ADDR  = PORT_Z_BASE_ADDR + 12'h01A; // Peripheral Multiplexing Bits [21:20]
   parameter PORT_Z_PINMUX11_ADDR  = PORT_Z_BASE_ADDR + 12'h01B; // Peripheral Multiplexing Bits [23:22]
   parameter PORT_Z_PINMUX12_ADDR  = PORT_Z_BASE_ADDR + 12'h01C; // Peripheral Multiplexing Bits [25:24]
   parameter PORT_Z_PINMUX13_ADDR  = PORT_Z_BASE_ADDR + 12'h01D; // Peripheral Multiplexing Bits [27:26]
   parameter PORT_Z_PINMUX14_ADDR  = PORT_Z_BASE_ADDR + 12'h01E; // Peripheral Multiplexing Bits [29:28]
   parameter PORT_Z_PINMUX15_ADDR  = PORT_Z_BASE_ADDR + 12'h01F; // Peripheral Multiplexing Bits [31:30]
   parameter PORT_Z_PINCFG00_ADDR  = PORT_Z_BASE_ADDR + 12'h020; // Pin Configuration Bit 00
   parameter PORT_Z_PINCFG01_ADDR  = PORT_Z_BASE_ADDR + 12'h021; // Pin Configuration Bit 01 
   parameter PORT_Z_PINCFG02_ADDR  = PORT_Z_BASE_ADDR + 12'h022; // Pin Configuration Bit 02 
   parameter PORT_Z_PINCFG03_ADDR  = PORT_Z_BASE_ADDR + 12'h023; // Pin Configuration Bit 03 
   parameter PORT_Z_PINCFG04_ADDR  = PORT_Z_BASE_ADDR + 12'h024; // Pin Configuration Bit 04 
   parameter PORT_Z_PINCFG05_ADDR  = PORT_Z_BASE_ADDR + 12'h025; // Pin Configuration Bit 05 
   parameter PORT_Z_PINCFG06_ADDR  = PORT_Z_BASE_ADDR + 12'h026; // Pin Configuration Bit 06 
   parameter PORT_Z_PINCFG07_ADDR  = PORT_Z_BASE_ADDR + 12'h027; // Pin Configuration Bit 07 
   parameter PORT_Z_PINCFG08_ADDR  = PORT_Z_BASE_ADDR + 12'h028; // Pin Configuration Bit 08 
   parameter PORT_Z_PINCFG09_ADDR  = PORT_Z_BASE_ADDR + 12'h029; // Pin Configuration Bit 09 
   parameter PORT_Z_PINCFG10_ADDR  = PORT_Z_BASE_ADDR + 12'h02A; // Pin Configuration Bit 10 
   parameter PORT_Z_PINCFG11_ADDR  = PORT_Z_BASE_ADDR + 12'h02B; // Pin Configuration Bit 11 
   parameter PORT_Z_PINCFG12_ADDR  = PORT_Z_BASE_ADDR + 12'h02C; // Pin Configuration Bit 12 
   parameter PORT_Z_PINCFG13_ADDR  = PORT_Z_BASE_ADDR + 12'h02D; // Pin Configuration Bit 13 
   parameter PORT_Z_PINCFG14_ADDR  = PORT_Z_BASE_ADDR + 12'h02E; // Pin Configuration Bit 14 
   parameter PORT_Z_PINCFG15_ADDR  = PORT_Z_BASE_ADDR + 12'h02F; // Pin Configuration Bit 15 
   parameter PORT_Z_PINCFG16_ADDR  = PORT_Z_BASE_ADDR + 12'h030; // Pin Configuration Bit 16 
   parameter PORT_Z_PINCFG17_ADDR  = PORT_Z_BASE_ADDR + 12'h031; // Pin Configuration Bit 17 
   parameter PORT_Z_PINCFG18_ADDR  = PORT_Z_BASE_ADDR + 12'h032; // Pin Configuration Bit 18 
   parameter PORT_Z_PINCFG19_ADDR  = PORT_Z_BASE_ADDR + 12'h033; // Pin Configuration Bit 19 
   parameter PORT_Z_PINCFG20_ADDR  = PORT_Z_BASE_ADDR + 12'h034; // Pin Configuration Bit 20 
   parameter PORT_Z_PINCFG21_ADDR  = PORT_Z_BASE_ADDR + 12'h035; // Pin Configuration Bit 21 
   parameter PORT_Z_PINCFG22_ADDR  = PORT_Z_BASE_ADDR + 12'h036; // Pin Configuration Bit 22 
   parameter PORT_Z_PINCFG23_ADDR  = PORT_Z_BASE_ADDR + 12'h037; // Pin Configuration Bit 23 
   parameter PORT_Z_PINCFG24_ADDR  = PORT_Z_BASE_ADDR + 12'h038; // Pin Configuration Bit 24 
   parameter PORT_Z_PINCFG25_ADDR  = PORT_Z_BASE_ADDR + 12'h039; // Pin Configuration Bit 25 
   parameter PORT_Z_PINCFG26_ADDR  = PORT_Z_BASE_ADDR + 12'h03A; // Pin Configuration Bit 26 
   parameter PORT_Z_PINCFG27_ADDR  = PORT_Z_BASE_ADDR + 12'h03B; // Pin Configuration Bit 27 
   parameter PORT_Z_PINCFG28_ADDR  = PORT_Z_BASE_ADDR + 12'h03C; // Pin Configuration Bit 28 
   parameter PORT_Z_PINCFG29_ADDR  = PORT_Z_BASE_ADDR + 12'h03D; // Pin Configuration Bit 29 
   parameter PORT_Z_PINCFG30_ADDR  = PORT_Z_BASE_ADDR + 12'h03E; // Pin Configuration Bit 30 
   parameter PORT_Z_PINCFG31_ADDR  = PORT_Z_BASE_ADDR + 12'h03F; // Pin Configuration Bit 31 



   
endpackage 

   // import into $UNIT 
   import evo_addr_pkg::*; 

 

`endif 
