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

module evo_clkrst
  #(parameter CLOCK_SELECT = 2'h1, // 0=reserved, 1=60MHz, 2=120MHz, 3=reserved 
    parameter RESET_DELAY = 32'h00000010
    )
   (// clks/resets - - - - - -
    input        clk_in, // from I/O
    input        core_rstn,
    // output clocks, most are placeholders for future use
    output logic pwr_on_nrst, // set by pll lock/unlock
    output logic reset_n,
    output logic pll_locked,
    output logic clk_bsp, // Clock selected by CLOCK_SELECT
    output logic clk_60, //      60MHz clock from PLL
    output logic clk_120, //    120MHz clock from PLL
    output logic clk_16, //      16MHz clock
    output logic clk_32, //      32MHz clock
    output logic en1mhz,
    output logic en16mhz
    );
   
   //-------------------------------------------------------
   // Local Parameters
   //-------------------------------------------------------
   // Setting CLKCNT=4 assumes that the ref clock used for the enXmhz signals is 16MHZ
   localparam CLKCNT_WIDTH = 7; // counter needed to get from clock speed down to 1MHz
   localparam CLKCNT = (CLOCK_SELECT == 1) ? 'd59 : 'd119;
   localparam R120TO16 = 4'h7; // 120/16 = 7 clocks, 
   
   //-------------------------------------------------------
   // Reg/Wire Declarations
   //-------------------------------------------------------
   /*AUTOWIRE*/
   /*AUTOREG*/
   logic [31:0]             reset_counter;
   logic [CLKCNT_WIDTH-1:0] clkcnt;
   logic                    reset_n_r;
   logic                    locked_prev;
   logic                    locked_sync;
   logic                    clk_16from32;
   logic                    clk_16from32_f;
   
   //-------------------------------------------------------
   // Functions and Tasks
   //-------------------------------------------------------
   
   //-------------------------------------------------------
   // Main Code
   //-------------------------------------------------------
   
   // Generate a reset signal for the logic that is delayed to start after the Hinj comes out of reset
   always_ff @(posedge clk_in or negedge core_rstn)  begin
      if (!core_rstn) reset_counter <= RESET_DELAY;
      else reset_counter <= (reset_counter != 0) ? (reset_counter - 1) : 32'h0;
   end
   always_comb reset_n = (reset_counter == 0);

   
`ifdef PLL_SIM_MODEL
   // In simulation the input clock is 16Mhz, not 12Mhz as in the Evo hardware
   // Clock rates: 12 MHz = 83.33 ns
   //              60 MHz = 16.67 ns        16 MHz = 62.50 ns         
   //             120 MHz =  8.33 ns        32 MHz = 31.25 ns          
   reg                  locked_reg;

   initial locked_reg = 1'b0;
   initial begin
      clk_60  = 1'b0;
      clk_120 = 1'b0;
      clk_16  = 1'b0;
      clk_32  = 1'b0;
   end
   always @(posedge clk_in) locked_reg <= 1'b1;
   assign pll_locked = locked_reg;
   always #8.333333ns  clk_60  = !clk_60;
   always #4.166667ns  clk_120 = !clk_120;
   always #31.25ns     clk_16  = !clk_16;
   always #15.625ns    clk_32  = !clk_32;

`else // !`ifdef PLL_SIM_MODEL
   // In hardware we use a PLL
   //======================================================================
   // Instance Name:  alt_pll_inst
   // Module Type:    alt_pll
   //======================================================================
   alt_pll
     alt_pll_inst 
       (.inclk0 (clk_in),
        .c0     (clk_60),
        .c1     (clk_120), 
        .c2     (clk_16), 
        .c3     (clk_32), 
        .locked (pll_locked)
        );

`endif // !`ifdef PLL_SIM_MODEL
   // create enables for 16MHz, 1MHz, 128kHz timers
   generate 
      if (CLOCK_SELECT == 2) begin: CS2
         assign clk_bsp = clk_120;
     end 
      else if (CLOCK_SELECT == 1) begin: CS1
         assign clk_bsp = clk_60;
     end 
   endgenerate

   // generate a pulse every 1000ns (1 MHz)
   always @(posedge clk_bsp) begin
      if (clkcnt != {CLKCNT_WIDTH{1'b0}}) begin
         clkcnt  <= clkcnt - 1;
         en1mhz  <= 1'b0;
      end else begin // in simulation, initial X on clkcnt should fall through to here
         clkcnt  <= CLKCNT;
         en1mhz  <= 1'b1;
      end
   end // always @ (posedge clk_bsp)

   // Create a one clock pulse every 62.5ns (16MHz)
   //   First,reate a 16MHz clock by dividing a 32MHz clock
   always @(posedge clk_32) begin
      if (!core_rstn) begin
         clk_16from32 <= 1'b0;
      end else begin
         clk_16from32 <= !clk_16from32;
      end
   end
   //   Then, detect rising edge and create pulse
   always @(posedge clk_bsp) begin
      clk_16from32_f <= clk_16from32;
      en16mhz <= clk_16from32 & ! clk_16from32_f;
   end
   
   // Filter the pll lock signal. In high noise environments it
   //  can glitch low while the clock coming out of the pll is still
   //  good enough to use. On a logic analyzer the glitch low appears
   //  to be around 2.7us wide. 63 cycles at 16MHz would be just under 4us.
   // Altera documentation says "The lock signal is an asynchronous
   //  output of the PLL", so we first synchronize it
   synch lock_sync (.dout     (locked_sync),
                    .clk      (clk_in),
                    .din      (pll_locked));

   // Altera Max 10 documentation says "Registers in the device
   //  core always power up to a low (0) logic level". We're relying
   //  on that for these two
   reg [5:0] lock_count        = 6'b0;
   reg       pll_lock_filtered = 1'b0;

   // Lets wait about 4us (4000ns). The clk_in is assumed to be 12MHz
   // Why 4us? See above comment for the pll lock
   // 12MHz => 83.33ns clock cycle, so about 48 clocks cycles = 4us. 
   // For simplcity we will use 64 clocks
   always @(posedge clk_in) begin
      locked_prev <= locked_sync;
      if (locked_prev == locked_sync) begin
         // just after the rising edge of locked_sync
         if (&lock_count) begin // after 63 cycles of same level, use it
            pll_lock_filtered <= locked_sync;
         end else begin
            lock_count <= lock_count + 1;
         end
      end else begin
         lock_count <= 0;
      end
   end
   
   // Power on Reset generator
   //always @(posedge clk_in or negedge pll_locked) begin
   always @(posedge clk_in or negedge pll_lock_filtered) begin
      if (!pll_lock_filtered) begin
         reset_n_r <= 1'b0;
         pwr_on_nrst <= 1'b0;
      end else begin
         reset_n_r <= 1'b1;
         pwr_on_nrst <= reset_n_r;
      end
   end
   
   
   
endmodule
