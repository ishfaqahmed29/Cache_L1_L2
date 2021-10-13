/*  1. Check for "cache_miss" signal to be active
    2. If MISS, Bit-Pseudo-LRU Replacement 
    3. Send req to L2 with tag
*/

module l1_to_l2 (
    input                   clk,
    input                   rst,
    //  Qualifier Signal(s)
    input                   cache_miss,
    input       [15:0]      addr,
    output                  req_to_l2,
    output      [15:0]      addr_tag,
    output      [255:0]     data
);
    
    reg [31:0]  cache_valid;                // Valid Block
    reg [31:0]  cache_tag   [0:15];         // Tag Block
    reg [31:0]  cache_data  [0:255];        // Data Block

    //  bit-PLRU Algorithm
    reg [31:0]  mru_bit;
    integer     mru_count;

    integer     line_count;
    
    reg         req_to_l2;

    wire [15:0]     addr_tag;
    wire [255:0]    data;

    assign addr_tag = (req_to_l2) ? cache_tag: 1'bz;
    assign data = (req_to_l2) ? cache_data: 1'bz;

    
    //  Logic To Send Request to L2 (40 clocks latency!)
    always_comb begin
        if (req_to_l2) begin
            for (int i=0; i<31; ++i) begin
                //  check tag, if not found set tag for l2
                if (cache_tag != addr) begin
                    addr_tag = addr;
                end
            end
        end
    end
    

    // Cache MISS logic
    always @(posedge clk) begin
        if (rst) begin
            //  Check for Cache MISS
            if (cache_miss) begin
                //  MISS
                req_to_l2 = 1;
                for (int i=0; i<31; ++i) begin
                    if (cache_tag[i] == addr) begin
                        mru_bit[i] = 1;
                        mru_count++;
                        line_count++;
                        if (mru_count == 31) begin
                            mru_count = 0;
                            for (int j=0; j<31 && j!=i; ++j) begin
                                mru_bit[j] = 0;
                            end
                            break;
                        end
                        else if (line_count == 31) begin
                            line_count = 0;
                            break;
                        end
                    end
                end
            end
        end
    end

endmodule