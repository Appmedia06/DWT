module DWT_1D1L
(
    input   wire            sys_clk,
    input   wire            sys_rst,
    
    output  wire     [7:0]   high_o,
    output  wire     [7:0]   low_o
);

wire [7:0]   even, odd ;
wire [7:0]   sub1, sub2, add1, add2;
reg [7:0]   d1out, d2out, d3out, d4out;
reg         sel;
reg [7:0]   Ld1out,Ld2out,Ld3out,Ld4out,Ld5out;
reg [4:0]   cnt1;
reg [7:0]   data;
/*
    High: sub2
    Low:  Ld5out
*/

assign  high_o = sub2;
assign  low_o = Ld5out;


assign even = sel ? data: 8'bz; 
assign odd = sel ? 8'bz: data; 

always@(posedge  sys_clk) 
    if(sys_rst == 0) 
        sel <= 1'b0;    
    else  
        sel <= ~sel;  
    
assign sub1 = $signed(even) - $signed(d1out); 
assign sub2 = $signed(d3out) - $signed(d1out); 
assign add1 = $signed(Ld2out) + ($signed(d4out) >>> 2); 
assign add2 = $signed(Ld4out) + ($signed(d4out) >>> 2); 

//d2 
always@(posedge  sys_clk) 
    if(sys_rst==0) begin  
        d2out<=8'd0; 
        d3out<=8'd0; 
        d4out<=8'd0; 
        Ld1out<=8'd0;   
        Ld2out<=8'd0; 
        Ld3out<=8'd0; 
        Ld4out<=8'd0; 
        Ld5out<=8'd0;  
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



// d1 
always@(posedge  sys_clk) 
    if(sys_rst==0) 
        d1out<=8'd0;    
    else       
        d1out <= $signed(odd) >>> 1; 
 
always@(posedge  sys_clk) 
    if(sys_rst==0) 
        cnt1 <= 4'h0;    
    else
        cnt1 <= cnt1 + 1; 
        
// rom
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
        default  : data = 8'd0 ; 
    endcase    
end

endmodule 
