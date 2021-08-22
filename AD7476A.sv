`timescale 1ns / 1ps
/*
This module reads serial data from an AD7476A ADC chip

The chip can sanmples at 1MSPS and sends data out serially on the falling edge of sck. The serial clock(sck) can be between 10Khz
and 20MHz. 

Samples are triggerd by de-asserting SS. There must be at least 50ns between the last sample ending and the next sample starting
by deasswerting SS. 

There are 16 clks for each sample, the first 4 are always zero and the next 12 are data starting with the MSB first. 

To keep things simple, this module will generate sck, and assert SS high every 17th clock cycle. 

*/


module AD7476A #(
  CLK_DIVISOR = 122 // divide clk by CLK_DIVISOR. clk frequency/CLK_DIVISOR/17 = sample rate. 122 default assumes 100MKz clk giving a sample rate of 48.216kHz
)(
  input             Clk  ,
  input             Miso ,
  output            Ss   ,
  output            Sck  ,
  output reg [11:0] Data ,
  output reg        Valid
);

localparam CNT_WIDTH = $clog2(CLK_DIVISOR);

logic [CNT_WIDTH-1:0] clk_cnt        = '0;
logic [5:0]           serial_clk_cnt = '0;
logic                 serial_clock       ;
logic [11:0]          data               ;
logic                 ss                 ;

always @(posedge Clk) begin
  ss <= Ss;
  if(clk_cnt == CLK_DIVISOR) begin
    clk_cnt <= '0;
  end else begin
    clk_cnt <= clk_cnt + 1;
  end
  
  if(clk_cnt == '0) begin
    if(serial_clk_cnt == 5'h10) begin
      serial_clk_cnt <= 5'h00;
    end else begin
      serial_clk_cnt <= serial_clk_cnt + 1;
    end
    serial_clock <= 1'b1;
  end else if(clk_cnt == (CLK_DIVISOR/2)) begin
    serial_clock <= 1'b0;
  end else begin
    serial_clock <= serial_clock;
  end
  
  if(Ss) begin
    Data <= data;
  end else begin
    Data  <= Data;
  end
  
  if(ss==1'b0 && Ss == 1'b1) begin //rising edge detect Ss
    Valid <= 1'b1;
  end else begin
    Valid <= 1'b0;
  end
  
  case(serial_clk_cnt)
    5: data[11] <= Miso;
    6: data[10] <= Miso;
    7: data[9]  <= Miso;
    8: data[8]  <= Miso;
    9: data[7]  <= Miso;
    10: data[6] <= Miso;
    11: data[5] <= Miso;
    12: data[4] <= Miso;
    13: data[3] <= Miso;
    14: data[2] <= Miso;
    15: data[1] <= Miso;
    16: data[0] <= Miso;
    default: data <= data;
  endcase
end

assign Ss = (serial_clk_cnt == '0) ? 1'b1 : 1'b0;
assign Sck = serial_clock;

endmodule
