`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2021 09:25:21 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input in,
    input clk,
    input reset,
    output out
    );
    
    parameter TERM_COUNT = 18'd250_000;
    reg [18:0] count = 4'b0;
    reg last_in = in;
    
    always @ (posedge clk) begin
        
        // Update state of last input
        last_in <= in;
        
        if (!reset == 1'b0 | last_in != in) begin
            
            // Reset count without updating output signal
            count <= 18'b0;
        end
        else begin
            if (count == TERM_COUNT) begin
            
                // Reset couunt and update output signal
                count <= 18'b0;
                out <= in;
            end
            else begin
                count <= count_out + 18'b1;
            end
        end
    end
endmodule
