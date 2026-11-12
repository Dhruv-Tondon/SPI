
module master_main(input clk,rst,start,MISO,
input [7:0] LOAD_data,
output logic CS,MOSI,BUSY,sclk,tick,
output logic [7:0] REC_data);

logic load,en;

master_fsm uut1 (.clk(clk),.rst(rst),
.tick(tick),.start(start),
.en(en),.load(load),.CS(CS));

spi_master_shift_reg uut2(.clk(clk),.rst(rst),
.tick(tick),.load(load),
.MISO(MISO),.LOAD_data(LOAD_data),
.MOSI(MOSI),.en(en),.sclk(sclk));

clkgen #(10)uut3(.clk(clk),.sclk(sclk),
.tick(tick),.rst(rst));

assign BUSY=en;

endmodule


module tb_main;

logic clk, rst,LOAD, start,MISO;
logic [7:0]LOAD_data;

wire CS,MOSI,BUSY;

master_main dut (
    .clk(clk),.rst(rst),
    .start(start),.MISO(MISO),
    .LOAD_data(LOAD_data),.CS(CS),.MOSI(MOSI),.BUSY(BUSY)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("spi_master.vcd");
    $dumpvars(0, tb_main);

    clk = 0;rst = 1;
    start = 0;
    MISO = 0;  LOAD_data = 8'hA5;

    #20;
    rst = 0;
    #10;
    
    start = 1;
    #10;
    start = 0;

    // MISO random pattern for eg.
    forever begin
        #100 MISO = ~MISO;
    end
end

initial begin
    #2000;
    $finish;
end

endmodule
