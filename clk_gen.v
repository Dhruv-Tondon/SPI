module spi_clk_gen #(
    parameter DIV = 4   
)(input logic clk,rst,en,
  output logic sclk,tick
);

logic [$clog2(DIV)-1:0] count;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        sclk <= 0;
        tick <= 0;
    end else begin
        tick <= 0;  

        if (enable) begin
            if (count == (DIV/2 - 1)) begin
                count <= 0;
                sclk  <= ~sclk;
                if (sclk == 0)tick <= 1;
            end else begin
                count <= count +1;
            end
        end else begin
            count <= 0;
            sclk <= 0;
        end
    end
end

endmodule