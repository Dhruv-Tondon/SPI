module slave_main(
    input rst,start,sclk,CS,MOSI,
    input [7:0] LOAD_data,

    output logic MISO,BUSY,
    output logic [7:0] REC_data
);

logic load,en;

slave_fsm uut1 (
    .rst(rst),.start(start),
    .CS(CS),.en(en),.load(load)
);

spi_slave_shift_reg uut2 (
    .rst(rst),.load(load),
    .MOSI(MOSI),.LOAD_data(LOAD_data),
    .MISO(MISO),.REC_data(REC_data),
    .en(en),.sclk(sclk)
);

assign BUSY = en;

endmodule


module tb_slave;

logic rst,start,sclk,CS,MOSI;
logic [7:0] LOAD_data;

wire MISO,BUSY;
wire [7:0] REC_data;

slave_main dut (
    .rst(rst),.CS(CS),
    .start(start),.sclk(sclk),
    .MOSI(MOSI),.LOAD_data(LOAD_data),
    .MISO(MISO),.BUSY(BUSY),.REC_data(REC_data)
);

always #50 sclk = ~sclk;


initial begin

    $dumpfile("spi_slave.vcd");
    $dumpvars(0,tb_slave);

    sclk = 0;
    rst = 1;
    start = 0;
    CS = 1;
    MOSI = 0;

    LOAD_data = 8'h3C;

    #20;
    rst = 0;

    #20;
    CS = 0;

    start = 1;
    @(negedge sclk);
    start = 0;

    //data: 10110101
    @(negedge sclk) MOSI = 1;
    @(negedge sclk) MOSI = 0;
    @(negedge sclk) MOSI = 1;
    @(negedge sclk) MOSI = 1;
    @(negedge sclk) MOSI = 0;
    @(negedge sclk) MOSI = 1;
    @(negedge sclk) MOSI = 0;
    @(negedge sclk) MOSI = 1;

    @(negedge sclk);
    CS = 1;

    #100;

    $display("REC_data = %b",REC_data);
    $display("MISO     = %b",MISO);

    $finish;

end

endmodule


