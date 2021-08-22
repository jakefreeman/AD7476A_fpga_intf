`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2021 10:13:56 PM
// Design Name: 
// Module Name: AD7476A_tb
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


module AD7476A_tb();

logic        clk = 1'b1;
logic        miso      ;
logic        ss        ;
logic        sck       ;
logic [11:0] data      ;
logic        ampPWM    ;
logic        ampSD     ;

logic [15:0] test_data = '0;
logic [15:0] test_data_flipped;
logic [5:0]  count = '0;

assign test_data_flipped = {<<{test_data}};

always begin
  #5 clk <= ~clk;
end

always @(negedge sck) begin
  if(ss == 1'b0) begin
    test_data <= test_data;
    count <= count + 1;
    miso <= test_data_flipped[count];
  end else begin
    test_data <= test_data + 1;
    count <= '0;
    miso  <= '0;
  end
end
    

AD7476A_top AD7476A_top_inst(
  .clk   (clk   ),
  .miso  (miso  ),
  .ss    (ss    ),
  .sck   (sck   ),
  .led   (data  ),
  .ampPWM(ampPWM),
  .ampSD (ampSD )
);



endmodule
