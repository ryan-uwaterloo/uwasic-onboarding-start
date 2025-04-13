module spi_peripheral (
    input wire clk,
    input wire rst_n,
    input wire read_write,
    input wire valid,
    input wire [6:0] addr,
    input wire [7:0] data,
    // reg bank
    output reg [7:0] en_reg_out_7_0,
    output reg [7:0] en_reg_out_15_8,
    output reg [7:0] en_reg_pwm_7_0,
    output reg [7:0] en_reg_pwm_15_8,
    output reg [7:0] pwm_duty_cycle
);

    always @(posedge clk) begin
        if (!reset_n) begin //resets
            en_reg_out_7_0 <= 0;
            en_reg_out_15_8 <= 0;
            en_reg_pwm_7_0 <= 0;
            en_reg_pwm_15_8 <= 0;
            pwm_duty_cycle <= 0;
        end else if (valid) begin
            if(read_write) begin //this is our write
                case(addr) //addr
                    7'h00: en_reg_out_7_0   <= data;
                    7'h01: en_reg_out_15_8  <= data;
                    7'h02: en_reg_pwm_7_0   <= data;
                    7'h03: en_reg_pwm_15_8  <= data;
                    7'h04: pwm_duty_cycle   <= data;
                    default: ; //do nothing if not valid addr
                endcase
            end
        end
    end


endmodule