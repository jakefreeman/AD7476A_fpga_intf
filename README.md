# AD7476A FPGA reciever
Systemverilog implementation for receiving data from an AD7476A ADC chip.

The AD7476A is an analog-to-digital converter capable of 1Msps, and sends data via a SPI interface. This module generates the necessary chip select and serial clock signals required by the ADC. The data is output from the module's Data port and has a valid indicator that is asserted for one clock for each new sample recieved. The sample rate is controlled via a CLK_DIVISOR paramter where sample_rate=(clock frequency)/CLK_DIVISOR/17.

<pre><code>
   _____________________
  |Clk[0:0]      Ss[0:0]|
  |Miso[0:0]    Sck[9:0]|
  |           Data[11:0]|
  |           Valid[0:0]|
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯  
</code></pre>
Inputs:
- Clk: Logic clock. Must be >= 17*samplerate
- Miso: SPI Controller-in-Peripheral-Out. Routs off-chip to the AD7476A's sdata port

Outputs:                              __
- Ss: Chip Select. Routes to AD7476A's cs port
- Sck: Serial Clock. Routes AD7476A's sclk port
- Data: 12-bit data from AD7476A
- Valid: Asserted for one 'Clk' cycle for each sample indicating 'Data' is valid
