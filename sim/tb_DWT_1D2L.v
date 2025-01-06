`timescale 1ns/1ps

module tb_DWT_1D2L;
    reg             sys_clk;
    reg             sys_rst;

    wire    [7:0]   low_out;
    wire    [7:0]   high_out;
    
    parameter DATA_SIZE = 31;
    reg [7:0] memory [0:DATA_SIZE-1];
    wire [7:0] data;
    reg [4:0] idx;
    
    assign data = memory[idx];

    DWT_1D2L_ver2 DWT_1D2L_ver2 (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .data_in(data),
        
        .high_o(high_out),
        .low_o(low_out)
    );

    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; 
    end

    initial begin

        $readmemh("C:/Users/user/FPGA project/My code/DWT/data/output_hex.txt", memory);
        
        sys_rst = 0;
        idx = 0;

        #10 sys_rst = 1;

        repeat(DATA_SIZE) begin
          #10;
          idx = idx + 1;
        end        

        #2000;

        $finish;
    end

    // 輸出監控
    initial begin
        $monitor("Time: %0t | Low Out: %d | High Out: %d",
                 $time, low_out, high_out);
    end

endmodule
