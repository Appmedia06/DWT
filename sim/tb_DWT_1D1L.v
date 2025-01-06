`timescale 1ns/1ps

module tb_DWT_1D1L;
    reg             sys_clk;
    reg             sys_rst;

    wire    [7:0]   low_out;
    wire    [7:0]   high_out;

    DWT_1D1L DWT_1D1L (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        
        .high_o(high_out),
        .low_o(low_out)
    );


    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; 
    end

    initial begin

        sys_rst = 0;

        #10 sys_rst = 1;


        #300;

        $finish;
    end

    initial begin
        $monitor("Time: %0t | Low Out: %d | High Out: %d",
                 $time, low_out, high_out);
    end

endmodule
