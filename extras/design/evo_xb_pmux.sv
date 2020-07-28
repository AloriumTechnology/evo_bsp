///////////////////////////////////////////////////////////////////
//=================================================================
//  Copyright(c) Alorium Technology Inc., 2020
//  ALL RIGHTS RESERVED
//=================================================================
//
// File name:  : evo_xb_pmux.sv
// Author      : Steve Phillips
// Description :
// 
//   This module is a parameritized PMUX module that allows the
// OpenEvo user to specify a minimum amount of muxing for the PMUX
// functioanlity. This replaced the previous, SAMD compatible, PMUX
// implementation that used a large amount of FPGA resources whether
// it was needed or not.
//
//   The user will specify the number of PMUX inputs for each
// port. Each port has only a singe MUX_WIDTH value, so the user
// should determine which pin in a port needs the most PMUX inputs and
// set the whole port to that maximum number. Each port has a seperate
// MUX_WIDTH though, so each port will be different.
// 
//   
// 
// 
//=================================================================
///////////////////////////////////////////////////////////////////

module evo_xb_pmux
  #(// How many PMUX inputs per port
    parameter D_MUX_WIDTH =  1,
    parameter E_MUX_WIDTH =  1,
    parameter F_MUX_WIDTH =  1,
    parameter G_MUX_WIDTH =  1,
    parameter Z_MUX_WIDTH =  1
   )
   (
    // Interface to IP blocks___________________________
    //      Pmux controls for Port D
    input [(PORT_D_DWIDTH*D_MUX_WIDTH)-1:0] port_d_dir_i,
    input [(PORT_D_DWIDTH*D_MUX_WIDTH)-1:0] port_d_out_i,
    input [(PORT_D_DWIDTH*D_MUX_WIDTH)-1:0] port_d_en_i, 
    //      Pmux controls for Port E
    input [(PORT_E_DWIDTH*E_MUX_WIDTH)-1:0] port_e_dir_i,
    input [(PORT_E_DWIDTH*E_MUX_WIDTH)-1:0] port_e_out_i,
    input [(PORT_E_DWIDTH*E_MUX_WIDTH)-1:0] port_e_en_i, 
    //      Pmux controls for Port F
    input [(PORT_F_DWIDTH*F_MUX_WIDTH)-1:0] port_f_dir_i,
    input [(PORT_F_DWIDTH*F_MUX_WIDTH)-1:0] port_f_out_i,
    input [(PORT_F_DWIDTH*F_MUX_WIDTH)-1:0] port_f_en_i, 
    //      Pmux controls for Port G
    input [(PORT_G_DWIDTH*G_MUX_WIDTH)-1:0] port_g_dir_i,
    input [(PORT_G_DWIDTH*G_MUX_WIDTH)-1:0] port_g_out_i,
    input [(PORT_G_DWIDTH*G_MUX_WIDTH)-1:0] port_g_en_i, 
    //      Pmux controls for Port Z
    input [(PORT_Z_DWIDTH*Z_MUX_WIDTH)-1:0] port_z_dir_i,
    input [(PORT_Z_DWIDTH*Z_MUX_WIDTH)-1:0] port_z_out_i,
    input [(PORT_Z_DWIDTH*Z_MUX_WIDTH)-1:0] port_z_en_i, 
    // Interface to Ports_______________________________
    //      Pmux controls for Port D
    output logic [PORT_D_DWIDTH-1:0]        port_d_dir_o,
    output logic [PORT_D_DWIDTH-1:0]        port_d_out_o,
    output logic [PORT_D_DWIDTH-1:0]        port_d_en_o,
    //      Pmux controls for Port E
    output logic [PORT_E_DWIDTH-1:0]        port_e_dir_o,
    output logic [PORT_E_DWIDTH-1:0]        port_e_out_o,
    output logic [PORT_E_DWIDTH-1:0]        port_e_en_o,
    //      Pmux controls for Port F
    output logic [PORT_F_DWIDTH-1:0]        port_f_dir_o,
    output logic [PORT_F_DWIDTH-1:0]        port_f_out_o,
    output logic [PORT_F_DWIDTH-1:0]        port_f_en_o,
    //      Pmux controls for Port G
    output logic [PORT_G_DWIDTH-1:0]        port_g_dir_o,
    output logic [PORT_G_DWIDTH-1:0]        port_g_out_o,
    output logic [PORT_G_DWIDTH-1:0]        port_g_en_o,
    //      Pmux controls for Port Z
    output logic [PORT_Z_DWIDTH-1:0]        port_z_dir_o,
    output logic [PORT_Z_DWIDTH-1:0]        port_z_out_o,
    output logic [PORT_Z_DWIDTH-1:0]        port_z_en_o
    );

   // PORT D
   always_comb begin
      // Set default values to 0
      port_d_dir_o = {PORT_D_DWIDTH{1'h0}};
      port_d_out_o = {PORT_D_DWIDTH{1'h0}};
      port_d_en_o  = {PORT_D_DWIDTH{1'h0}};
      // For each pmux input for the port, and for each pin of that
      // port, check the corresponding EN bit. If is is set, the set
      // he output En for that pin and set the values of DIR and OUT.
      for (int dmux=0; dmux < D_MUX_WIDTH; dmux++) begin
         for (int dpin=0; dpin < PORT_D_DWIDTH; dpin++) begin
            if (port_d_en_i[((dmux*PORT_D_DWIDTH)+dpin)]) begin
               port_d_dir_o[dpin] = port_d_dir_i[((dmux*PORT_D_DWIDTH)+dpin)];
               port_d_out_o[dpin] = port_d_out_i[((dmux*PORT_D_DWIDTH)+dpin)];
               port_d_en_o[dpin] = 1'b1;
            end
         end
      end
   end // always_comb

   // PORT E
   always_comb begin
      // Set default values to 0
      port_e_dir_o = {PORT_E_DWIDTH{1'h0}};
      port_e_out_o = {PORT_E_DWIDTH{1'h0}};
      port_e_en_o  = {PORT_E_DWIDTH{1'h0}};
      // For each pmux input for the port, and for each pin of that
      // port, check the corresponding EN bit. If is is set, the set
      // he output En for that pin and set the values of DIR and OUT.
      for (int emux=0; emux < E_MUX_WIDTH; emux++) begin
         for (int epin=0; epin < PORT_E_DWIDTH; epin++) begin
            if (port_e_en_i[((emux*PORT_E_DWIDTH)+epin)]) begin
               port_e_dir_o[epin] = port_e_dir_i[((emux*PORT_E_DWIDTH)+epin)];
               port_e_out_o[epin] = port_e_out_i[((emux*PORT_E_DWIDTH)+epin)];
               port_e_en_o[epin] = 1'b1;
            end
         end
      end
   end // always_comb

   // PORT F
   always_comb begin
      // Set default values to 0
      port_f_dir_o = {PORT_F_DWIDTH{1'h0}};
      port_f_out_o = {PORT_F_DWIDTH{1'h0}};
      port_f_en_o  = {PORT_F_DWIDTH{1'h0}};
      // For each pmux input for the port, and for each pin of that
      // port, check the corresponding EN bit. If is is set, the set
      // he output En for that pin and set the values of DIR and OUT.
      for (int fmux=0; fmux < F_MUX_WIDTH; fmux++) begin
         for (int fpin=0; fpin < PORT_F_DWIDTH; fpin++) begin
            if (port_f_en_i[((fmux*PORT_F_DWIDTH)+fpin)]) begin
               port_f_dir_o[fpin] = port_f_dir_i[((fmux*PORT_F_DWIDTH)+fpin)];
               port_f_out_o[fpin] = port_f_out_i[((fmux*PORT_F_DWIDTH)+fpin)];
               port_f_en_o[fpin] = 1'b1;
            end
         end
      end
   end // always_comb

   // PORT G
   always_comb begin
      // Set default values to 0
      port_g_dir_o = {PORT_G_DWIDTH{1'h0}};
      port_g_out_o = {PORT_G_DWIDTH{1'h0}};
      port_g_en_o  = {PORT_G_DWIDTH{1'h0}};
      // For each pmux input for the port, and for each pin of that
      // port, check the corresponding EN bit. If is is set, the set
      // he output En for that pin and set the values of DIR and OUT.
      for (int gmux=0; gmux < G_MUX_WIDTH; gmux++) begin
         for (int gpin=0; gpin < PORT_G_DWIDTH; gpin++) begin
            if (port_g_en_i[((gmux*PORT_G_DWIDTH)+gpin)]) begin
               port_g_dir_o[gpin] = port_g_dir_i[((gmux*PORT_G_DWIDTH)+gpin)];
               port_g_out_o[gpin] = port_g_out_i[((gmux*PORT_G_DWIDTH)+gpin)];
               port_g_en_o[gpin] = 1'b1;
            end
         end
      end
   end // always_comb

   // PORT Z
   always_comb begin
      // Set default values to 0
      port_z_dir_o = {PORT_Z_DWIDTH{1'h0}};
      port_z_out_o = {PORT_Z_DWIDTH{1'h0}};
      port_z_en_o  = {PORT_Z_DWIDTH{1'h0}};
      // For each pmux input for the port, and for each pin of that
      // port, check the corresponding EN bit. If is is set, the set
      // he output En for that pin and set the values of DIR and OUT.
      for (int zmux=0; zmux < Z_MUX_WIDTH; zmux++) begin
         for (int zpin=0; zpin < PORT_Z_DWIDTH; zpin++) begin
            if (port_z_en_i[((zmux*PORT_Z_DWIDTH)+zpin)]) begin
               port_z_dir_o[zpin] = port_z_dir_i[((zmux*PORT_Z_DWIDTH)+zpin)];
               port_z_out_o[zpin] = port_z_out_i[((zmux*PORT_Z_DWIDTH)+zpin)];
               port_z_en_o[zpin] = 1'b1;
            end
         end
      end
   end // always_comb
   
endmodule // evo_xb_pmux
