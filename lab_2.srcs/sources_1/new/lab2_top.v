`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2021 08:45:35 PM
// Design Name: 
// Module Name: lab2_top
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


module lab2_top(
    input btnC,
    input [15:14] sw,
    input btnU,
    input clk,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Vsync,
    output Hsync,
    output /*sev seg*/
    );
    
    wire clk_25mhz;
    wire reset_hi;
    wire reset_lo;
    wire db_button;
    wire [15:14] db_sw;
    
    assign reset_lo = !reset_hi;
    
    clk_mmcm_wiz clk_mmcm_wizi (.clk_25mhz(clk_25mhz),
                                .reset(btnC),
                                .locked(reset_hi),
                                .clk_in1(clk));
                                
    seven_seg seven_segi ( .dispA (4'd9), 
                           .dispB (4'd7), 
                           .dispC (4'd2), 
                           .dispD (4'd4), 
                           .clk (clk_25mhz),
                           .reset (reset_lo)/*outs*/);
                           
    debounce debouncei ( .in (btnU),
                         .clk (clk25mhz),
                         .reset (reset_lo),
                         .out (db_button));
                         
    debounce debounceii ( .in (sw[14]),
                          .clk (clk25mhz),
                          .reset (reset_lo),
                          .out (db_sw[14]));
                         
    debounce debounceiii ( .in (sw[15]),
                           .clk (clk25mhz),
                           .reset (reset_lo),
                           .out (db_sw[15]));
                         
    vga_sel vga_seli (
 .sw (db_sw[15:14]),
                       .clk (clk_25mhz),
                       .button (db_button),
                       .reset(reset_hi),
                       .r (vgaRed[3:0]),
                       .g (vgaGreen[3:0]),
                       .b (vgaBlue[3:0])
,
                       .VS (Vsync),
                       .HS (Hsync));
    
    
endmodule
