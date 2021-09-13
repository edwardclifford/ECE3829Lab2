`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2021 12:19:07 PM
// Design Name: 
// Module Name: vga_sel
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


module vga_sel(
    input [1:0] sw,
    input clk,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output HS,
    output VS,
    );
    
// Basic structure:

/* Outer counter: VSync
416_800 clk ticks per cylce
1_600 clk ticks for low pulse
23_200 clk ticks for back porch
8_000 clk ticks for front porch
384_000 clk ticks for display time
/*

/* Inner counter: HSync
800 clk ticks per cycle
96 clk ticks for low pulse
48 clk ticks for back porch
16 clk ticks for front porch
640 clk ticks for display time
*/
parameter VSYNC_PULSE = 416_800;
parameter VSYNC_DISP = 384_000;
parameter VSYNC_BP = 23_200;
parameter VSYNC_FP = 8_000;
parameter VSYNC_PULSE_WIDTH = 1_600;
parameter VSYNC_DISP_START = VSYNC_PULSE_WIDTH + VSYNC_BP;
parameter VSYNC_DISP_END = VSYNC_DISP_START + VSYNC_DISP;

parameter HSYNC_PULSE = 800;
parameter HSYNC_DISP = 640;
parameter HSYNC_BP = 48;
parameter HSYNC_FP = 16;
parameter HSYNC_PULSE_WIDTH = 96;
parameter HSYNC_DISP_START = HSYNC_PULSE_WIDTH + HSYNC_BP;
parameter HSYNC_DISP_END = HSYNC_DISP_START + HSYNC_DISP;

reg [15:0] VS_ctr = 0;
reg [15:0] HS_ctr = 0;

// Configure sync pulse
assign VS = (VS_ctr > 0 && VS_ctr < VSYNC_PULSE_WIDTH) ? 0 : 1;
assign HS = (HS_ctr > 0 && HS_ctr < HSYNC_PULSE_WIDTH) ? 0 : 1;

always @ (posedge clk) begin

    // Update counters
    if (VS_ctr > VSYNC_PULSE) begin
        VS_ctr <= 0;
    end else begin
        VS_ctr <= VS_ctr + 1;
    end

    if (HS_ctr > HSYNC_PULSE) begin
        HS_ctr <= 0;
    end else begin
        HS_ctr <= HS_ctr + 1;
    end

    // Assign colors for current gun loc
    case (sw)

    2'b00: begin    // Blue screen
        r <= 4'b0000;
        b <= 4'b1000;
        g <= 4'b0000;
    end

    2'b01: begin    // Green purp alt
        if (HS_ctr > HSYNC_DISP_START && HS_ctr < HSYNC_DISP_END) begin
            if (HS_ctr[6]) begin
                r <= 4'b0000;
                b <= 4'b0000;
                g <= 4'b1000;
            end else begin
                r <= 4'b1000;
                b <= 4'b1000;
                g <= 4'b0000; 
            end
        end
    end

    2'b10: begin    // Red box
        if (HS_ctr > HSYNC_DISP_END - 64 && VS_ctr > VS_DISP_END - 64) begin
            r <= 4'b1000;
            b <= 4'b0000;
            g <= 4'b0000; 
        end else begin
            r <= 4'b0000;
            b <= 4'b0000;
            g <= 4'b0000;   
        end
    end

    2'b11: begin    // White line
        if (HS_ctr > HSYNC_DISP_END - 16) begin
            r <= 4'b1000;
            b <= 4'b1000;
            g <= 4'b1000;
        end else begin
            r <= 4'b0000;
            b <= 4'b0000;
            g <= 4'b0000;
        end
    end

end

/* Display options
    - Blue display
        - Set color to blue

    - Horizontal bars of green & purple
        - Every 32 clock cycles (in HSync disp range) alternate colors

    - Red block bottom right
        - For second half of VSync disp & second half of HSync disp, red
        - Black otherwise

    - White strip left side
        - For last 16 cylces in HSync disp, set white
*/
endmodule
