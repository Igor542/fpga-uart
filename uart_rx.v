module uart_rx(input wire clk, input wire reset, input wire rx,
        output [7:0] data, output wire ready);
    localparam [2:0]
        IDLE = 2'd0,
        DATA = 2'd1,
        STOP = 2'd2;

    reg [2:0] state;
    reg [4:0] oversampling_counter;
    reg [3:0] bit;

    always@(negedge reset) begin
        state <= IDLE;
        oversampling_counter <= 0;
        bit <= 0;
        ready <= 0;
    end

    always@(posedge clk) begin
        case (state)
            IDLE:
                if (rx == 0 && oversampling_counter == 4'd7) begin
                    oversampling_counter <= 0;
                    state <= DATA;
                    data <= 0;
                    bit <= 0;
                    ready <= 0;
                end else begin
                    oversampling_counter <= oversampling_counter + 1;
                end
            DATA:
                if (oversampling_counter == 4'd15) begin
                    oversampling_counter <= 0;
                    data <= {rx, data[7:1]};
                    bit <= bit + 1;
                    if (bit == 3'd7) begin
                        bit <= 0;
                        state <= STOP;
                    end
                end else begin
                    oversampling_counter <= oversampling_counter + 1;
                end 
            STOP:
                if (oversampling_counter == 4'd15) begin
                    ready <= 1;
                    state <= IDLE;
                    oversampling_counter <= 0;
                end else begin
                    oversampling_counter <= oversampling_counter + 1;
                end
        endcase
    end
endmodule
