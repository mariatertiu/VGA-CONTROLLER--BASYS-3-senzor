`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 10:17:59
// Design Name: 
// Module Name: topp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module topp(
    input        clk        ,
    input        reset      ,
    input        pir_signal ,
    output       h_sync     ,
    output       v_sync     ,
    output [3:0] vgaRed     ,
    output [3:0] vgaGreen   ,
    output [3:0] vgaBlue    ,
    output  [0:0]     led 
  
    );
    
 wire clk_148Mhz ;
wire [0:0] led;


  
 design_1_wrapper design_1_wrapper_i(
         .clk_in1_0 (clk),
         .clk_out1_0(clk_148Mhz),
         .reset_0   (reset)
         );
        
        
        
 vga_sync vga_inst (
        .clk_148Mhz (clk_148Mhz),
        .reset     (reset)     ,
        .pir_signal(pir_signal),
        .h_sync    (h_sync)    ,
        .v_sync    (v_sync)    ,
        .red       (vgaRed)    ,
        .green     (vgaGreen)  ,
        .blue      (vgaBlue)   ,
        .led       (led)
      //  .x_pos     ()     ,
       // .y_pos     ()
         
    );
    



    
endmodule
