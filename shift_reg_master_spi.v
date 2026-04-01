module spi_master_shift_reg (input clk,rst,tick,load,MISO,
input [7:0] LOAD_data,
output logic MOSI);

logic [7:0]REC_data,[7:0] SEND_data;

always_ff@(posedge clk or posedge rst) begin

    if(rst)begin
        REC_data<=0;
        SEND_data<=0;
    end
    else begin 
        if(load) SEND_data<=LOAD_data;
        else if(tick) begin
            REC_data<={REC_data[6:0],MISO};
            MOSI <= SEND_data[7];
            SEND_data <= {SEND_data[6:0], 1'b0};
        end
    end
end

endmodule


