`ifndef _EVO_BSP_PKG_DONE 

  `define _EVO_BSP_PKG_DONE      // set flag that pkg already included 


 

package evo_bsp_pkg; 

   //---------------------------------------------------------------------------
   // GPIO
   //
   // Bundle the pinmux control lines up into a struct
   typedef struct packed {
      logic [31:0] dir;
      logic [31:0] out;
      logic [31:0] en;
   } evo_gpio_pmux_ctl_t;

   //---------------------------------------------------------------------------



   //---------------------------------------------------------------------------
   // FLASH
   //
   // evo_flashload_ctrl status CSR
   typedef struct packed
                  {
                     logic [31:25]          rsrv1;         // [31:25] - reserved -
                     logic                  reset_rcfg;    // [24]    We received a ctl.reset_rcfg

                     logic                  wap_wait_done; // [23]    Flash returned Error
                     logic                  wap_chk_rdy;   // [22]    Flash returned Error after last word
                     logic                  wap_wait_rdy;  // [21]    Flash returned Error after writing CMD
                     logic                  crc;           // [20]    CRC Error

                     logic                  erase;         // [19]    Erase Error
                     logic [2:0]            ers_sec;       // [18:16] Sector that caused Erase Error  

                     logic [15:5]           rsrv0;         // [15:5]  - reserved -
                     logic                  wap_done;      // [4]     Write APAGE SM complete

                     logic                  gap_done;      // [3]     Get APAGE SM complete
                     logic                  ers_done;      // [2]     Flash Erase completed                 
                     logic                  idle;          // [1]     Flashload module idle
                     logic                  error;         // [0]     Indicates we found an error
                  } evo_flash_sts_t;
   
   // evo_flashload_ctrl control CSR
   typedef struct packed
                  {
                     logic [31:8]           rsrv;    // [31:8]
                     logic                  reset_rcfg;  // [7] Abort the current reconfig process 
                                                         //       and return to idle state
                     logic                  disable_crc; // [6] Do not set status.crc or status.error 
                                                         //       on CRC error
                     logic                  rcfg;        // [5] Indicates we should start reconfiguration 
                                                         //       sequence
                     logic                  sec;         // [4] indicates which image to reconfigure 
                                                         //       (CFM0 or CFM1)
                     logic                  dc;          // [3] Indicates we should access DualConfig IP
                     logic                  set_img;     // [2] Indicates we should set active image
                     logic                  act_img;     // [1] Indicates image to make active
                     logic                  ld_img;      // [0] Indicates we should reboot to the selected 
                                                         //       active image
                  } evo_flash_ctl_t;

   // Set of bits to track current state of ERS SEC state machine
   typedef struct packed
                  {
                     logic                  err;     // [6] Error
                     logic                  chk_sts; // [5] Check Status
                     logic                  rd_sts;  // [4] Read Status
                     logic                  ctl;     // [3] Set Control
                     logic                  clr_sts; // [2] Cleat Status
                     logic                  secsel;  // [1] Sector Select
                     logic                  idle;    // [0] Idle
                  } evo_ers_st_t;
   
   //---------------------------------------------------------------------------

  //////////////////////////////////////////////////////////////////
  // PCC stuff
  //////////////////////////////////////////////////////////////////
  localparam PCC_MAX_DMA_BURST_SIZE = 1024; // max number of transfers with dma burst
  localparam PCC_MAX_DMA_NUM_BURST  =  512; // max number of bursts

  typedef logic [$clog2(PCC_MAX_DMA_BURST_SIZE+1)-1:0] evo_pcc_flit_cnt_t; // # of xfers on PCC within burst
  typedef logic [$clog2(PCC_MAX_DMA_NUM_BURST+1)-1:0]  evo_pcc_burst_cnt_t; // # of  bursts with PCC
  typedef struct packed {
    logic        den1;          // pcc den, unused--evo does not connect to SAMD
    logic        den2;          // pcc den, unused--evo does not connect to SAMD
    logic        clk;           // PCC clk.  functions as vld.  will be held to 0 when not transmitting
    logic [13:0] data;          // 13:10, 7:0 connected to SAMD
  } evo_pcc_t;
  
endpackage // evo_bsp_pkg

   // import into $UNIT 
   import evo_bsp_pkg::*; 

 

 `endif //  `ifndef _EVO_BSP_PKG_DONE
   
/*   
   // Some additional structs I considered for the GPIO stuff
 
   typedef struct packed {
      logic [31:0] in;
   } evo_gpio_pin_t;

   typedef struct packed {
      evo_gpio_pmux_ctl_t [15:0] d;
      evo_gpio_pmux_ctl_t [15:0] e;
      evo_gpio_pmux_ctl_t [15:0] f;
      evo_gpio_pmux_ctl_t [15:0] g;
      evo_gpio_pmux_ctl_t [15:0] z;
   } evo_gpio_pmux_ports_t;

   typedef struct packed {
      evo_gpio_pin_t [15:0] d;
      evo_gpio_pin_t [15:0] e;
      evo_gpio_pin_t [15:0] f;
      evo_gpio_pin_t [15:0] g;
      evo_gpio_pin_t [15:0] z;
   } evo_gpio_pmux_t;
*/   

      /*

I've defined a struct like so:

   typedef struct packed {
      logic [31:0] dir;
      logic [31:0] out;
      logic [31:0] en;
   } evo_gpio_pmux_ctl_t;



The path starts in the d2f module:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module evo_d2f
   (   .
       .
    output evo_gpio_pmux_ctl_t    port_d_pmux_ctl_o,
    input logic [31:0]            port_d_pmux_in_i,
       .
);
       .
      port_d_pmux_ctl_o.dir   =  {16'h0, ( dir_f[15:0] & PINMASK)};
       .
endmodule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



It then goes up to the evo_core where it goes over and connects to the evo_gpio

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module evo_core ();
       .
   evo_gpio_pmux_ctl_t [15:0] port_d_pmux_ctl;
   logic [31:0]               port_d_pmux_in;
       .
evo_gpio evo_gpio_inst (
       .
    .port_d_pmux_ctl_i        (port_d_pmux_ctl),
    .port_d_pmux_in_o         (port_d_pmux_in),
       .
);

evo_d2f evo_d2f_inst (
       .
      .port_d_pmux_ctl_o              (port_d_pmux_ctl[0]),
      .port_d_pmux_in_i               (port_d_pmux_in),
       .
);
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



It then goes into the evo_gpio and connects to the evo_port module

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module evo_gpio(
       .
    input evo_gpio_pmux_ctl_t [15:0] port_d_pmux_ctl_i,
    output logic [31:0]              port_d_pmux_in_o,
       .
);
evo_port evo_port_d_inst(
       .
      .pmux_ctl_i        (port_d_pmux_ctl_i),
      .pmux_in_o         (port_d_pmux_in_o),
       .
);
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



Finally, in the evo_port it is used

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module evo_port (
       .
    input                         evo_gpio_pmux_ctl_t [15:0] pmux_ctl_i,
    output logic [31:0]           pmux_in_o,
       .
);
       .
   always_comb begin
      // For each pin in the port
      for (int pin=0; pin<PORT_DWIDTH; pin++) begin
         pinmux_dir[pin] = pmux_ctl_i[pinmux_f[pin]].dir[pin];
   end
       .
endmodule

    
    
    */
