
module spi_slave_shift_reg(
    input rst,load,MOSI,
    input [7:0] LOAD_data,
    input en,sclk,

    output logic MISO,
    output logic [7:0] REC_data
);

logic [7:0] SEND_data;


// Receive MOSI on rising edge
always_ff @(posedge sclk or posedge rst) begin

    if (rst) begin
        REC_data <= 8'd0;
    end

    else if (en) begin
        REC_data <= {REC_data[6:0],MOSI};
    end

end

// Transmit MISO on falling edge
always_ff @(negedge sclk or posedge rst) begin

    if (rst) begin
        SEND_data <= 8'd0;
        MISO <= 1'b0;
    end

    else if (en) begin

        if (load) begin
            SEND_data <= LOAD_data;
            MISO <= LOAD_data[7];
        end

        else begin
            SEND_data <= {SEND_data[6:0],1'b0};
            MISO <= SEND_data[6];
        end

    end

end

endmodule