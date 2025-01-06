module dmux2
(
    input   wire     [7:0]   data_i,
    input   wire             sel,
    
    output  reg      [7:0]   data1_o,
    output  reg      [7:0]   data2_o
);

always@(*) 
    if(sel == 0) begin
            data1_o <= data_i;
            data2_o <= 8'b0;
        end
    else    begin  
            data1_o <= 8'b0;
            data2_o <= data_i;
        end
 
endmodule 
