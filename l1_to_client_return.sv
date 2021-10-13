/*  1. Check for ack from L2 
    2. Store data in L1 Cache
    3. Send ack to Client with data
*/

module l1_to_client_return (
    input                   clk,
    input                   rst,
    //  Qualifier Signal(s)
    input       [15:0]      addr,
    input                   ack_to_l1,
    output                  ack_to_cl,
    output      [15:0]      addr_tag,
    inout       [255:0]     data
);
    
    reg [31:0]  cache_valid;                // Valid Block
    reg [31:0]  cache_tag   [0:15];         // Tag Block
    reg [31:0]  cache_data  [0:255];        // Data Block

    reg [31:0]  tag_valid;
    reg         ack_to_cl;

    reg         cache_hit;

    wire [15:0]     addr_tag;
    wire [31:0]     mux_data_in;   
    wire [255:0]    data;

    assign addr_tag = (ack_to_cl) ? cache_tag: 1'bz;
    assign data = (ack_to_cl) ? cache_data: 1'bz;

    // Send data to client    
    always_comb begin
        if (ack_to_l1) begin
            for (int i=0; i<31; ++i) begin
                if (cache_valid[i]) begin
                    cache_tag[i] = addr;
                end
                line_count++;
                if (line_count == 31) begin
                    line_count = 0;
                    break;
                end
            end
        end
    end

    //  Compare Tags
    always_comb begin
        if (ack_to_l1) begin
            for (int i=0; i<31; ++i) begin
                if (cache_tag[i] == addr) begin
                tag_valid[i] = 1;
                cache_valid[i] = 1;
                ack_to_cl = 1'b1;
                end else begin
                tag_valid[i] = 0;
                cache_valid[i] = 0;
                ack_to_cl = 1'b0;
                end
            end
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

    //  MUX Logic
    always_comb begin
        if (cache_hit && ack_to_cl) begin
            case (cache_data) 
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