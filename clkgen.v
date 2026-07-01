module clkgen #(parameter div = 10)(
    input clk ,rst ,
    output logic sclk, tick  
);

reg [$clog2(div)-1:0] counter=0;


always_ff@(posedge clk or posedge rst) begin
    if(rst)begin
    counter<=0;
    sclk<=0;
    tick<=0;
    end
    else if(counter==div/2-1) begin
    counter<=0;
    sclk<=~sclk;
    tick<=1;
    end
    else begin
    tick<=0;
    counter<=counter+1;
    end
end

endmodule


module tb();
parameter N=10;
reg clk,rst;
wire sclk,tick; 
clkgen #(N)uut(.clk(clk),.sclk(sclk),.tick(tick),.rst(rst));
initial clk= 0 ;
always #5 clk = ~clk;
 
initial begin
    $dumpfile("clkgendump.vcd");
    $dumpvars(0, tb);
    $display("Starting simulation...");
    #500;  
    $display("Simulation finished");
    $finish;
end
initial begin
    rst=1; #5;
    rst=0; #5;
end
endmodule 