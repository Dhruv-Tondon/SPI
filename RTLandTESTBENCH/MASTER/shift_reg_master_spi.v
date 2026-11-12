

module spi_master_shift_reg (input clk,rst,tick,load,MISO,en,sclk,
input [7:0] LOAD_data,
output logic MOSI
output logic [7:0] REC_data);

logic [7:0] SEND_data;

always_ff@(posedge clk or posedge rst) begin

    if(rst)begin
        REC_data<=0;
        SEND_data<=0;
        MOSI<=0;
    end 
    else begin
    if (load) begin
        SEND_data <= LOAD_data;
        MOSI <= LOAD_data[7];
    end

    else if (tick && en) begin
        if (sclk) begin
            // Rising edge: sample MISO
            REC_data <= {REC_data[6:0], MISO};
        end
        else begin
            // Falling edge: prepare next MOSI bit
            SEND_data <= {SEND_data[6:0], 1'b0};
            MOSI <= SEND_data[6];
        end
    end
end
end

endmodule
