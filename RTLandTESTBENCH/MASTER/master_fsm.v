module master_fsm(input clk,rst,tick,start,
output logic en,load,CS);

logic [3:0] bitcount=0;

typedef enum logic [1:0] {IDLE,START,SHIFT,STOP} state;
state state_c,state_n;

always @(posedge clk or posedge rst) begin
    if (rst) state_c <= IDLE;
    else state_c <= state_n;
end

always @(posedge clk or posedge rst)begin
    if (rst) bitcount<=0;
    else if (state_c == IDLE && start) bitcount <= 0;
    else if (state_c == SHIFT && tick) begin
        if (bitcount == 15 && tick) bitcount <= 0;
        else bitcount <= bitcount + 1;
        end
end


always@(*) begin
    state_n = state_c;
    case (state_c)
        IDLE:  if (start) state_n = START;
        START: if (tick)  state_n = SHIFT;
        SHIFT: if (bitcount == 15 && tick) state_n = STOP;
        STOP:  state_n = IDLE;
        default:  if (start) state_n = START;
    endcase
end

always_comb begin
    load= 0;
    en= 0;
    CS = 1;
    case(state_c)
        IDLE: begin en = 0;
        if (start)
        load = 1; 
        end
        START:CS = 0;
        SHIFT:begin 
            en=1;
            CS=0;
        end
        STOP: en=0;
        default: en=0;
    endcase
end
endmodule
