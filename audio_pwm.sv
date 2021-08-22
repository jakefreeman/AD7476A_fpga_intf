`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2021 09:39:03 PM
// Design Name: 
// Module Name: audio_pwm
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


module audio_pwm(
  input Clk,
  input Valid,
  input [11:0] Data,
  output Pwm_out
);

localparam CNT_WIDTH = $clog2(122*17);
localparam CNT_LIM   = 122*17;

logic [CNT_WIDTH-1:0] count = '0;
logic                 pwm       ;

always @(posedge Clk) begin
  if(Valid) begin
    count <= '0;
    pwm   <= '0;
  end else begin
    count <= count + 1;
    if(count <= (Data>>1) && count > 0) begin
      pwm <= 1'b1;
    end else begin
      pwm <= 1'b0;
    end
  end
end  

assign Pwm_out = pwm;

endmodule
