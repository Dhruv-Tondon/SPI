module spi_master_shift_reg (input clk,rst,tick,load,MISO,en,sclk,
input [7:0] LOAD_data,
output logic MOSI);

logic [7:0] REC_data,SEND_data;

always_ff@(posedge clk or posedge rst) begin

    if(rst)begin
        REC_data<=0;
        SEND_data<=0;
        MOSI<=0;
    end 
    else begin 
        if(load & sclk) begin 
            SEND_data<=LOAD_data;
            MOSI<=0;
        end

        else if(tick & ~sclk & en) begin
            REC_data<={REC_data[6:0],MISO};
            MOSI <= SEND_data[7];
            SEND_data <= {SEND_data[6:0], 1'b0};
        end
    end
end

endmodule

module tb1;

reg clk,rst,tick,load,MISO,en,sclk;
reg [7:0] LOAD_data ;
wire MOSI;
spi_master_shift_reg uut(.clk(clk),.rst(rst),.tick(tick),.load(load),.MISO(MISO),.LOAD_data(LOAD_data),.MOSI(MOSI),.en(en),.sclk(sclk));
initial begin clk= 0 ;
sclk= 0 ;
en=0;
tick=0;
load=0;
LOAD_data=0;
MISO=0;
end

always #5 clk = ~clk;

always begin
    #50 sclk=~sclk;   
    tick=1;
    #10 tick=0;
end

 
initial begin
    $dumpfile("master_shift+regdump.vcd");
    $dumpvars(0, tb1);
    $display("Starting simulation...");
    #2500;  
    $display("Simulation finished");
    $finish;
end
initial begin
    rst=1; #5;
    rst=0; #20;
    LOAD_data=8'b10110111;
    load=1; #50
    load=0;
    en=1;#1000
    en=0;
end
endmodule
