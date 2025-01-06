module mux2
(
    input   wire     [7:0]   data1_i,
    input   wire     [7:0]   data2_i,
    input   wire             sel,
    
    output  wire     [7:0]   data_o
);

assign  data_o = sel ? data2_i : data1_i;
 
endmodule 
