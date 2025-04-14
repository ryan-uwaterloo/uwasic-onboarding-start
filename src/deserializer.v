module deserializer #(
    parameter  CDC_LEN = 2
) (
    input wire clk,
    input wire sclk,
    input wire copi,
    input wire n_cs,
    input wire rst_n,
    output reg read_write,
    output reg [6:0] addr,
    output reg [7:0] data,
    output reg valid
);

//CDC
reg [CDC_LEN:0] sclk_cdc;
reg [CDC_LEN-1:0] copi_cdc;
reg [CDC_LEN-1:0] n_cs_cdc;

always @(posedge clk) begin
    sclk_cdc[0] <= sclk;
    copi_cdc[0] <= copi;
    n_cs_cdc[0] <= n_cs;
    for (integer i = 1; i < CDC_LEN; i = i + 1) begin
        sclk_cdc[i] <= sclk_cdc[i-1];
        copi_cdc[i] <= copi_cdc[i-1];
        n_cs_cdc[i] <= n_cs_cdc[i-1];
    end
    sclk_cdc[CDC_LEN] <= sclk_cdc[CDC_LEN-1];
end

reg [3:0] txn_count; //3 bits to count to 16
reg waiting_next_sclk;

always @(posedge clk or negedge rst_n) begin //asynch reset lol because sclk not guaranteed when resetting
    if (!rst_n) begin
        txn_count <= 15;
        read_write <= 0;
        addr <= 0;
        data <= 0;
        valid <= 0;
    end else if (sclk_cdc[CDC_LEN] && sclk_cdc[CDC_LEN-1]) begin
        if(!n_cs_cdc[CDC_LEN-1] && !waiting_next_sclk) begin //this is valid txn
            txn_count <= txn_count - 1;
            waiting_next_sclk <= 1; //only incr once per sclk
            valid <= txn_count == 0;
            if(txn_count == 15)begin //is r_W
                read_write <= copi_cdc[CDC_LEN-1];
            end else if(txn_count <= 7) begin //if data
                data[txn_count[2:0]] <= copi_cdc[CDC_LEN-1]; //msb-first
            end else begin //is addr
                addr[txn_count[2:0]] <= copi_cdc[CDC_LEN-1];
            end
        end
    end else if (!sclk_cdc[CDC_LEN]) begin
        waiting_next_sclk <= 0;
    end
end

endmodule