//===========================================================================
//  Copyright(c) Alorium Technology Group Inc., 2019
//  ALL RIGHTS RESERVED
//===========================================================================
//
// File name:  : evo_const_pkg.sv
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description : 
// 
//   This file defines conatants used within the design
//
//===========================================================================
`ifndef _EVO_CONST_PKG_DONE 

  `define _EVO_CONST_PKG_DONE      // set flag that pkg already included 


 

package evo_const_pkg; 

   parameter CLOCK_SELECT       = 0;  // 2 bits. 0=16MHZ, 1=32MHz, 2=64MHz, 3=reserved
   parameter PLL_SELECT         = 0;  // 1=50MHz PLL, 0=16MHz PLL
   parameter CSR_AWIDTH         = 12; // Width of CSR Address
   parameter CSR_DWIDTH         = 32; // Width of CSR Data bus
   parameter GPIO_DWIDTH        = 160; // Number of GPIO pins controlled here
   parameter GPIO_NUMPORTS      =  5; // Number of GPIO Ports
   parameter PMUX_CTL_WIDTH     = 1536; // Full width of the PMUX_CTL struct
   // I2C
   parameter EVO_TWCR_RST_VAL   = 8'h45; // Set Control Reg values
   parameter EVO_TWDR_RST_VAL   = 8'h00;
   parameter EVO_TWAR_RST_VAL   = 8'h10; // Default I2C ID = 16 (0x10)
   parameter EVO_TWSR_RST_VAL   = 8'hF8; // NO_STATE value
   parameter EVO_TWBR_RST_VAL   = 8'h48; // Bit Rate
   parameter EVO_TWAMR_RST_VAL  = 8'h00;
   // PLL
   parameter XLR8_PLL_CLK2_DIVIDE_BY   = 1;
   parameter XLR8_PLL_CLK2_DUTY_CYCLE  = 50;
   parameter XLR8_PLL_CLK2_MULTIPLY_BY = 4;
   parameter XLR8_PLL_CLK2_PHASE_SHIFT = "1953";
   parameter XLR8_PLL_CLK4_DIVIDE_BY   = 1;
   parameter XLR8_PLL_CLK4_DUTY_CYCLE  = 50;
   parameter XLR8_PLL_CLK4_MULTIPLY_BY = 2;
   parameter XLR8_PLL_CLK4_PHASE_SHIFT = "1953";
   // I2C_Reg constants
   parameter EVO_INFO_RST_VAL     = 32'h00;
   parameter EVO_REG0E_RST_VAL    = 32'h0E;
   parameter EVO_REG0F_RST_VAL    = 32'h0F;
   // D2F
   parameter D2F_DIR_RST_VAL    = 32'hFF7FFFFF; // Set passthru as F->D, except MISO [23] 
   parameter D2F_DIRCLR_RST_VAL =  0;
   parameter D2F_DIRSET_RST_VAL =  0;
   parameter D2F_DIRTGL_RST_VAL =  0;
   parameter D2F_EN_RST_VAL     = 32'h03800100; // Set D8,SCK,MOSI,MISO as Passthru (D8 for Neopixel)
   parameter D2F_ENCLR_RST_VAL  =  0;
   parameter D2F_ENSET_RST_VAL  =  0;
   parameter D2F_ENTGL_RST_VAL  =  0;
   // Port D
   parameter PORT_D_DWIDTH            = 26; 
   parameter PORT_D_PADMASK           = 32'h03803f73;
   parameter PORT_D_DIRX_RST_VAL      =  0; 
   parameter PORT_D_DIRCLRX_RST_VAL   =  0;
   parameter PORT_D_DIRSETX_RST_VAL   =  0;
   parameter PORT_D_DIRTGLX_RST_VAL   =  0;
   parameter PORT_D_OUTX_RST_VAL      =  0;
   parameter PORT_D_OUTCLRX_RST_VAL   =  0;
   parameter PORT_D_OUTSETX_RST_VAL   =  0;
   parameter PORT_D_OUTTGLX_RST_VAL   =  0;
   parameter PORT_D_CTRLX_RST_VAL     =  0;
   parameter PORT_D_WRCONFIGX_RST_VAL =  0;
   parameter PORT_D_EVCTRLX_RST_VAL   =  0;
   parameter PORT_D_PCMSK_RST_VAL     =  0;
    // Port E
   parameter PORT_E_DWIDTH            = 32; 
   parameter PORT_E_PADMASK           = 32'hFFFFFFFF;
   parameter PORT_E_DIRX_RST_VAL      =  0;
   parameter PORT_E_DIRCLRX_RST_VAL   =  0;
   parameter PORT_E_DIRSETX_RST_VAL   =  0;
   parameter PORT_E_DIRTGLX_RST_VAL   =  0;
   parameter PORT_E_OUTX_RST_VAL      =  0;
   parameter PORT_E_OUTCLRX_RST_VAL   =  0;
   parameter PORT_E_OUTSETX_RST_VAL   =  0;
   parameter PORT_E_OUTTGLX_RST_VAL   =  0;
   parameter PORT_E_CTRLX_RST_VAL     =  0;
   parameter PORT_E_WRCONFIGX_RST_VAL =  0;
   parameter PORT_E_EVCTRLX_RST_VAL   =  0;
   parameter PORT_E_PCMSK_RST_VAL     =  0;
    // Port F (FPGA_D)
   parameter PORT_F_DWIDTH            = 26;
   parameter PORT_F_PADMASK           = 32'h03803f73; // 0011111101110011;
   parameter PORT_F_DIRX_RST_VAL      =  0;
   parameter PORT_F_DIRCLRX_RST_VAL   =  0;
   parameter PORT_F_DIRSETX_RST_VAL   =  0;
   parameter PORT_F_DIRTGLX_RST_VAL   =  0;
   parameter PORT_F_OUTX_RST_VAL      =  0;
   parameter PORT_F_OUTCLRX_RST_VAL   =  0;
   parameter PORT_F_OUTSETX_RST_VAL   =  0;
   parameter PORT_F_OUTTGLX_RST_VAL   =  0;
   parameter PORT_F_CTRLX_RST_VAL     =  0;
   parameter PORT_F_WRCONFIGX_RST_VAL =  0;
   parameter PORT_F_EVCTRLX_RST_VAL   =  0;
   parameter PORT_F_PCMSK_RST_VAL     =  0;
    // Port G
   parameter PORT_G_DWIDTH            =  2; 
   parameter PORT_G_PADMASK           = 2'h3;
   parameter PORT_G_DIRX_RST_VAL      =  0;
   parameter PORT_G_DIRCLRX_RST_VAL   =  0;
   parameter PORT_G_DIRSETX_RST_VAL   =  0;
   parameter PORT_G_DIRTGLX_RST_VAL   =  0;
   parameter PORT_G_OUTX_RST_VAL      =  0;
   parameter PORT_G_OUTCLRX_RST_VAL   =  0;
   parameter PORT_G_OUTSETX_RST_VAL   =  0;
   parameter PORT_G_OUTTGLX_RST_VAL   =  0;
   parameter PORT_G_CTRLX_RST_VAL     =  0;
   parameter PORT_G_WRCONFIGX_RST_VAL =  0;
   parameter PORT_G_EVCTRLX_RST_VAL   =  0;
   parameter PORT_G_PCMSK_RST_VAL     =  0;
    // Port Z
   parameter PORT_Z_DWIDTH            = 10; 
   parameter PORT_Z_PADMASK           = 10'h3FF;
   parameter PORT_Z_DIRX_RST_VAL      =  0;
   parameter PORT_Z_DIRCLRX_RST_VAL   =  0;
   parameter PORT_Z_DIRSETX_RST_VAL   =  0;
   parameter PORT_Z_DIRTGLX_RST_VAL   =  0;
   parameter PORT_Z_OUTX_RST_VAL      =  0;
   parameter PORT_Z_OUTCLRX_RST_VAL   =  0;
   parameter PORT_Z_OUTSETX_RST_VAL   =  0;
   parameter PORT_Z_OUTTGLX_RST_VAL   =  0;
   parameter PORT_Z_CTRLX_RST_VAL     =  0;
   parameter PORT_Z_WRCONFIGX_RST_VAL =  0;
   parameter PORT_Z_EVCTRLX_RST_VAL   =  0;
   parameter PORT_Z_PCMSK_RST_VAL     =  0;

   // The value $clog2(CSR_DWIDTH/8) is the number of address bits
   // required to address the bytes in the dat reg. The address is
   // increased by this amount for the Avalon interconnect fabric and
   // then those bits are discarded by the IP blocks (usually).
   parameter MADR_MSB = CSR_AWIDTH+$clog2(CSR_DWIDTH/8);
   parameter MADR_LSB = $clog2(CSR_DWIDTH/8);
   
endpackage 

   // import into $UNIT 
   import evo_const_pkg::*; 

 

`endif 
