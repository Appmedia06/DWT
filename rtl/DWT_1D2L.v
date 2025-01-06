module DWT_1D2L
(
    input   wire            sys_clk,
    input   wire            sys_rst,
    
    output  wire     [7:0]   high_o,
    output  wire     [7:0]   low_o
);

wire [7:0]   even, odd ;
wire [7:0]   sub1, sub2, add1, add2;
reg [7:0]   d1out, d2out, d3out, d4out;
wire [7:0]  d4out_div4;
reg         sel;
reg [7:0]   Ld1out,Ld2out,Ld3out,Ld4out,Ld5out;
reg [4:0]   cnt1, cnt2;
reg [4:0]   cnt_muxA, cnt_muxB;
reg [7:0]   data;

wire     [7:0]   muxA_odd;
wire    [7:0]   muxB_even, muxC_d3out, muxD_Ld2out, muxE_Ld4out;

reg [7:0]   setD_reg1, setD_reg2, setD_reg3, setD_reg4;
reg [7:0]   setB_reg1, setB_reg2;
reg [7:0]   setC_reg1, setC_reg2;

wire         muxA_sel, muxB_sel;

/*
    High: sub2
    Low:  Ld5out
*/

assign  high_o = sub2;
assign  low_o = Ld5out;


/* assign even = sel ? data_i: 8'bz; 
assign odd = sel ? 8'bz: data_i;  */

dmux2 dmux2 
(
    .data_i(data),
    .sel(sel),

    .data1_o(even),
    .data2_o(odd)
);

always@(posedge  sys_clk) 
    if(sys_rst == 0) 
        sel <= 1'b1;    
    else  
        sel <= ~sel;  
        
assign  muxB_sel = (sel == 1'b1) && (cnt2 >= 5'd9);        
        
mux2 muxB
(
    .data1_i(even),
    .data2_i(setD_reg1),
    .sel(muxB_sel),

    .data_o(muxB_even)
);
assign sub1 = muxB_even - d1out; 


assign  muxC_sel = (sel == 1'b1) && (cnt2 >= 5'd9);

mux2 muxC
(
    .data1_i(d3out),
    .data2_i(setB_reg2),
    .sel(muxC_sel),

    .data_o(muxC_d3out)
);
assign sub2 = $signed(muxC_d3out) - $signed(d1out); 


assign  muxD_sel = (sel == 1'b0) && (cnt2 >= 5'd9);
mux2 muxD
(
    .data1_i(Ld2out),
    .data2_i(setD_reg4),
    .sel(muxD_sel),

    .data_o(muxD_Ld2out)
);
assign add1 = $signed(muxD_Ld2out) + $signed(d4out_div4); 

assign  muxE_sel = (sel == 1'b0) && (cnt2 >= 5'd9);
mux2 muxE
(
    .data1_i(Ld4out),
    .data2_i(setC_reg2),
    .sel(muxE_sel),

    .data_o(muxE_Ld4out)
);

assign d4out_div4 = $signed(d4out) >>> 2;

assign add2 = $signed(muxE_Ld4out) + $signed(d4out_div4); 

//d2 
always@(posedge  sys_clk) 
    if(sys_rst==0) begin  
        d2out  <= 8'd0; 
        d3out  <= 8'd0; 
        d4out  <= 8'd0; 
        Ld1out <= 8'd0;   
        Ld2out <= 8'd0; 
        Ld3out <= 8'd0; 
        Ld4out <= 8'd0; 
        Ld5out <= 8'd0;  
    end   
    else begin      
        d2out  <= sub1;  
        d3out  <= d2out; 
        d4out  <= sub2; 
        Ld1out <= data;   
        Ld2out <= Ld1out; 
        Ld3out <= add1; 
        Ld4out <= Ld3out; 
        Ld5out <= add2;  
    end 

assign  muxA_sel = (sel == 1'b0) && (cnt2 >= 5'd9);

mux2 muxA
(
    .data1_i(odd),
    .data2_i(setD_reg2),
    .sel(muxA_sel),

    .data_o(muxA_odd)
);

// d1 
always@(posedge  sys_clk) 
    if(sys_rst==0) 
        d1out <= 8'd0;    
    else       
        d1out <= $signed(muxA_odd) >>> 1;
        
/* Folding Reg Set D*/        
always@(posedge  sys_clk) 
    if(sys_rst == 0) begin 
        setD_reg1 <= 8'b0;
        setD_reg2 <= 8'b0;
        setD_reg3 <= 8'b0;
        setD_reg4 <= 8'b0;
                     
        setB_reg1 <= 8'b0;
        setB_reg2 <= 8'b0;
        
        setC_reg1 <= 8'b0;
        setC_reg2 <= 8'b0;
    end
    else begin
        setD_reg1 <= Ld5out;
        setD_reg2 <= setD_reg1;
        setD_reg3 <= setD_reg2;
        setD_reg4 <= setD_reg3;
        
        setB_reg1 <= d3out;
        setB_reg2 <= setB_reg1;
        
        setC_reg1 <= Ld4out;
        setC_reg2 <= setC_reg1;
    end
        
        
/* Count */
always@(posedge  sys_clk) 
    if(sys_rst==0) begin
        cnt1 <= 5'h0;    
        cnt2 <= 5'h0;
    end
    else if (cnt2 >= 5'b11111) begin
        cnt2 <= 5'd10;
        cnt1 <= cnt1 + 1; 
        
    end
    else begin
        cnt1 <= cnt1 + 1; 
        cnt2 <= cnt2 + 1;
    end
   
    

always@(cnt1) begin  
    case(cnt1)  
        5'b00000 : data = 8'd30;      
        5'b00001 : data = 8'd60;   
        5'b00010 : data = 8'd30; 
        5'b00011 : data = 8'd80;     
        5'b00100 : data = 8'd40; 
        5'b00101 : data = 8'd70;     
        5'b00110 : data = 8'd28;  
        5'b00111 : data = 8'd66;  
        5'b01000 : data = 8'd44;    
        5'b01001 : data = 8'd77;
        5'b01010 : data = 8'd35;     
        5'b01011 : data = 8'd52;  
        5'b01100 : data = 8'd32;  
        5'b01101 : data = 8'd72;    
        5'b01110 : data = 8'd20;
        5'b01111 : data = 8'd38;     
        5'b10000 : data = 8'd29;
        5'b10001 : data = 8'd62;
        5'b10010 : data = 8'd41;     
        5'b10011 : data = 8'd85;
        5'b10100 : data = 8'd39;
        5'b10101 : data = 8'd56;     
        5'b10110 : data = 8'd41;
        5'b10111 : data = 8'd68;
        5'b11000 : data = 8'd29;     
        5'b11001 : data = 8'd57;
        5'b11010 : data = 8'd39;
        5'b11011 : data = 8'd52;     
        5'b11100 : data = 8'd25;
        5'b11101 : data = 8'd68;
        5'b11110 : data = 8'd37;            
        default  : data = 8'd0 ; 
    endcase    
end
 
endmodule 
