/*  1. Send req to L1
    2. Check L1 Cache
    3. If Match, Cache HIT
*/

module client_to_l1 (
    input                   clk,
    input                   rst,
    //  Qualifier Signal(s)
    input                   req_to_l1,
    input       [15:0]      addr,
    output                  cache_miss,
    output      [15:0]      addr_tag,
    inout       [255:0]     data
);

    reg [31:0]  cache_valid;                // Valid Block
    reg [31:0]  cache_tag   [0:15];         // Tag Block
    reg [31:0]  cache_data  [0:255];        // Data Block

    reg [31:0]  tag_valid;
    
    reg         cache_hit;
    wire        cache_miss;

    //  bit-PLRU [Replacement Algorithm]
    reg [31:0]  mru_bit;
    integer     mru_count;

    integer     line_count;
    
    wire [31:0]     assert_cache_data;
    wire [31:0]     mux_data_in;
    wire [255:0]    data;

    assign assert_cache_data = tag_valid && cache_valid;
    assign mux_data_in = (assert_cache_data) ? cache_data: 1'bz;
    assign data = (mux_data_in) ? cache_data: 1'bz;
    assign cache_miss = (!cache_hit) ? 1'b1: 1'b0;

    //  Initial Conditions
    initial begin
        for (int i=0; i<31; ++i) begin
            cache_valid[i] = 0;
            cache_tag[i] = 0;
            cache_data[i] = 0;
            tag_valid[i] = 0;
            mru_bit[i] = 0;
        end
    end
    
    //  Reset 
    always_comb begin
        if (!rst) begin
            for (int i=0; i<31; ++i) begin
                cache_valid[i] = 0;
                cache_tag[i] = 0;
                cache_data[i] = 0;
                tag_valid[i] = 0;
                mru_bit[i] = 0;
            end
            mru_count = 0;
            line_count = 0;
        end    
    end

    //  Compare Tags
    always_comb begin
        if (req_to_l1) begin
            for (int i=0; i<31; ++i) begin
                if (cache_tag[i] == addr) begin
                tag_valid[i] = 1;
                cache_valid[i] = 1;
                end else begin
                tag_valid[i] = 0;
                cache_valid[i] = 0;
                end
            end
        end
    end

    //  Generate assert for data block from AND Logic
    always_comb begin
        for (int i=0; i<31; ++i) begin
            assert_cache_data[i] = tag_valid[i] & cache_valid[i];
        end
    end

    //  Set MUX input for each cache line
    always_comb begin
        for (int i=0; i<31; ++i) begin
            mux_data_in[i] = cache_data[i];
        end
    end

    //  Cache HIT Generator
    always_comb begin
        cache_hit = mux_data_in[0] | mux_data_in[1] | mux_data_in[2] | mux_data_in[3] | mux_data_in[4] | mux_data_in[5] | mux_data_in[6] | mux_data_in[7] | mux_data_in[8] | mux_data_in[9] | mux_data_in[10] | mux_data_in[11] | mux_data_in[12] | mux_data_in[13] | mux_data_in[14] | mux_data_in[15] | mux_data_in[16] | mux_data_in[17] | mux_data_in[18] | mux_data_in[19] | mux_data_in[20] | mux_data_in[21] | mux_data_in[22] | mux_data_in[23] | mux_data_in[24] | mux_data_in[25] | mux_data_in[26] | mux_data_in[27] | mux_data_in[28] | mux_data_in[29] | mux_data_in[30] | mux_data_in[31];
    end

    //  Cache HIT/MISS Logic
    always @(posedge clk) begin
        if (rst) begin
            //  Check for Cache HIT
            if (cache_hit != 0) begin
                //  HIT
                for (int i=0; i<31; ++i) begin
                    if (cache_tag[i] == addr) begin
                        mru_bit[i] = 1;
                        mru_count++;
                        line_count++;
                        if (mru_count == 31) begin
                            mru_count = 0;
                            break;
                            /*for (int j=0; j<31 && j!=i; ++j) begin
                                mru_bit[j] = 0;
                            end*/
                        end
                        else if (line_count == 31) begin
                            line_count = 0;
                            break;
                        end
                    end
                end
            end
            //  MISS
            else begin
                cache_miss = 1;
            end
        end
    end

    //  MUX Logic
    always_comb begin
        if (cache_hit) begin
            case (cache_valid) 
            4'h00:  data =   mux_data_in[0];
            4'h01:  data =   mux_data_in[1];
            4'h02:  data =   mux_data_in[2];
            4'h03:  data =   mux_data_in[3];
            4'h04:  data =   mux_data_in[4];
            4'h05:  data =   mux_data_in[5];
            4'h06:  data =   mux_data_in[6];
            4'h07:  data =   mux_data_in[7];
            4'h08:  data =   mux_data_in[8];
            4'h09:  data =   mux_data_in[9];
            4'h0a:  data =   mux_data_in[10];
            4'h0b:  data =   mux_data_in[11];
            4'h0c:  data =   mux_data_in[12];
            4'h0d:  data =   mux_data_in[13];
            4'h0e:  data =   mux_data_in[14];
            4'h0f:  data =   mux_data_in[15];
            4'h10:  data =   mux_data_in[16];
            4'h11:  data =   mux_data_in[17];
            4'h12:  data =   mux_data_in[18];
            4'h13:  data =   mux_data_in[19];
            4'h14:  data =   mux_data_in[20];
            4'h15:  data =   mux_data_in[21];
            4'h16:  data =   mux_data_in[22];
            4'h17:  data =   mux_data_in[23];
            4'h18:  data =   mux_data_in[24];
            4'h19:  data =   mux_data_in[25];
            4'h1a:  data =   mux_data_in[26];
            4'h1b:  data =   mux_data_in[27];
            4'h1c:  data =   mux_data_in[28];
            4'h1d:  data =   mux_data_in[29];
            4'h1e:  data =   mux_data_in[30];
            4'h1f:  data =   mux_data_in[31];
            default:data =   mux_data_in[0];
            endcase
        end
    end

endmodule