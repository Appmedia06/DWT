module DWT_2D1L
(
    input   wire            sys_clk,
    input   wire            sys_rst,
    
    output  wire             d1_over_o,
    output  wire             d2_high_over_o,
    output  wire             d2_low_over_o
);

parameter SIZE = 16; 
parameter L_SIZE = 6;
parameter H_SIZE = 7;
parameter IMAGE_SIZE = 16*16; 

reg [7:0] image [0:IMAGE_SIZE-1];

reg [7:0] Low   [0:SIZE-1][0:L_SIZE-1];
reg [7:0] High  [0:SIZE-1][0:H_SIZE-1];

reg [7:0] LL    [0:L_SIZE-1][0:L_SIZE-1];
reg [7:0] LH    [0:H_SIZE-1][0:L_SIZE-1];
reg [7:0] HL    [0:H_SIZE-1][0:L_SIZE-1];
reg [7:0] HH    [0:H_SIZE-1][0:H_SIZE-1];

parameter DELAY_CYCLES = 3;

initial begin
    $readmemh("C:/Users/user/FPGA project/My code/DWT/data/image.txt", image);
end

/* Dim 1 reg and wire */
reg     [10:0]       image_idx;
reg                  d1_processing;
reg     [2:0]        d1_delay_cnt;
reg     [7:0]        d1_data;
reg                  d1_DWT_rst;
wire                 d1_high_en;
wire    [7:0]        d1_high_o;
wire                 d1_low_en;
wire    [7:0]        d1_low_o;

reg     [3:0]        d1_high_row;
reg     [2:0]        d1_high_col;
reg     [3:0]        d1_low_row;
reg     [2:0]        d1_low_col;

reg                  d1_input_flag;
reg                  d1_first_flag;
reg     [5:0]        d1_line_cnt;

reg                  d1_over;

/* Dim 2 High reg and wire */

reg     [3:0]        high_row;
reg     [2:0]        high_col;

reg                  d2_H_processing;
reg     [2:0]        d2_H_delay_cnt;
reg     [7:0]        d2_H_data;
reg                  d2_H_DWT_rst;
wire                 d2_H_high_en;
wire    [7:0]        d2_H_high_o;
wire                 d2_H_low_en;
wire    [7:0]        d2_H_low_o;

reg     [4:0]        d2_HH_row;
reg     [4:0]        d2_HH_col;
reg     [4:0]        d2_HL_row;
reg     [4:0]        d2_HL_col;

reg                  d2_H_input_flag;
reg                  d2_H_first_flag;
reg     [5:0]        d2_H_line_cnt;
reg                  d2_high_over;

/* Dim 2 Low reg and wire */

reg     [3:0]        low_row;
reg     [2:0]        low_col;

reg                  d2_L_processing;
reg     [2:0]        d2_L_delay_cnt;
reg     [7:0]        d2_L_data;
reg                  d2_L_DWT_rst;
wire                 d2_L_high_en;
wire    [7:0]        d2_L_high_o;
wire                 d2_L_low_en;
wire    [7:0]        d2_L_low_o;

reg     [4:0]        d2_LL_row;
reg     [4:0]        d2_LL_col;
reg     [4:0]        d2_LH_row;
reg     [4:0]        d2_LH_col;

reg                  d2_L_input_flag;
reg                  d2_L_first_flag;
reg     [5:0]        d2_L_line_cnt;
reg                  d2_low_over;

/* DWT_2D1L output */ 
assign d1_over_o = d1_over;
assign d2_high_over_o = d2_high_over;
assign d2_low_over_o = d2_low_over;


/*----------Dim 1----------*/

always@(posedge  sys_clk) 
    if(sys_rst == 0) begin
        image_idx <= 0;
        d1_processing <= 1;
        d1_delay_cnt <= 0;
        d1_data <= 0;
        d1_DWT_rst <= 0;
        d1_first_flag <= 1;
        d1_line_cnt <= 0;
    end
    /* Input data to DWT_1D2L */
    else begin
        if (d1_processing && !d1_over) begin
            
            if (d1_input_flag) begin
                d1_data <= image[image_idx];
                image_idx <= image_idx + 1;
            end
            else begin
                d1_data <= image[image_idx];
            end
            
            if (d1_first_flag) begin
                d1_DWT_rst <= 1;
                d1_first_flag <= 0;
            end
            else begin                
                d1_DWT_rst <= 0;
            end

            if ((image_idx % SIZE) == (SIZE - 1)) begin
                d1_processing <= 0;
                d1_delay_cnt <= 0;
                d1_line_cnt <= d1_line_cnt + 1;
            end
        end
        /* Delay mode */
        else begin 
            d1_data <= 0;
            d1_delay_cnt <= d1_delay_cnt + 1;
            d1_first_flag <= 1;
            
            if (d1_delay_cnt == DELAY_CYCLES) begin
                d1_processing <= 1;
            end
        end
    end
    
/* Input flag */    
always@(posedge  sys_clk) 
    if(sys_rst == 0) begin
        d1_input_flag <= 0;
    end
    else if (d1_DWT_rst) begin
        d1_input_flag <= 1;
    end
    else if (d1_low_col == L_SIZE-1 && d1_processing == 0) begin
        d1_input_flag <= 0;
    end
    else begin
        d1_input_flag <= d1_input_flag;
    end

/* Dim 1 instance */ 
DWT_1D2L_for2D #(
    .SIZE(SIZE)
)
DWT_Dim1 (
    .sys_clk(sys_clk),
    .sys_rst(sys_rst),
    .data_in(d1_data),
    .DWT_rst(d1_DWT_rst),
    
    .high_en(d1_high_en),
    .high_o(d1_high_o),
    .low_en(d1_low_en),
    .low_o(d1_low_o)
);

/* Output to High and Low */ 
always@(posedge  sys_clk) begin
    if(sys_rst == 0) begin
        d1_high_row <= 0;
        d1_high_col <= 0;
        d1_low_row  <= 0;
        d1_low_col  <= 0;
        d1_over <= 0;
    end
    if (!d1_over) begin
        if (d1_high_row <= SIZE && d1_high_col <= H_SIZE) begin
            if (d1_high_en) begin
                High[d1_high_row][d1_high_col] <= d1_high_o;
                if (d1_high_col == H_SIZE-1) begin
                    d1_high_row <= d1_high_row + 1;
                    d1_high_col <= 0;
                end
                else begin
                    d1_high_col <= d1_high_col + 1;
                end
            end
        end
        if (d1_low_row <= SIZE && d1_low_col <= L_SIZE) begin
            if (d1_low_en) begin
                Low[d1_low_row][d1_low_col] <= d1_low_o;
                if (d1_low_col == L_SIZE-1) begin
                    d1_low_row <= d1_low_row + 1;
                    d1_low_col <= 0;
                end
                else begin
                    d1_low_col <= d1_low_col + 1;
                end
            end
        end    
    end
    if (d1_high_row == 0 && d1_high_col == 0 && d1_low_row == SIZE-1 && d1_low_col == L_SIZE-1) begin
        d1_over <= 1;
    end
end    


/*----------Dim 2----------*/    
    

/* Dim 2 High */
always@(posedge  sys_clk) 
    if(sys_rst == 0) begin
        high_row <= 0;
        high_col <= 0;
        d2_H_processing <= 1;
        d2_H_delay_cnt <= 0;
        d2_H_data <= 0;
        d2_H_DWT_rst <= 0;
        d2_H_first_flag <= 1;
        d2_H_line_cnt <= 0;    
    end    
    else begin
        if (d1_over) begin
            /* Input data to DWT_1D2L */
            if (d2_H_processing && !d2_high_over) begin
                
                if (d2_H_input_flag) begin
                    d2_H_data <= High[high_row][high_col];
                    if (high_row == SIZE-1) begin
                        high_col <= high_col + 1;
                        high_row <= 0;
                    end
                    else begin
                        high_row <= high_row + 1;
                    end
                end
                else begin
                    d2_H_data <= High[high_row][high_col];
                end
                
                
                if (d2_H_first_flag) begin
                    d2_H_DWT_rst <= 1;
                    d2_H_first_flag <= 0;
                end
                else begin                
                    d2_H_DWT_rst <= 0;
                end
               

                if (high_row == SIZE-1) begin
                    d2_H_processing <= 0;
                    d2_H_delay_cnt <= 0;
                    d2_H_line_cnt <= d2_H_line_cnt + 1;
                end
            end
            /* Delay mode */
            else begin 
                d2_H_data <= 0;
                d2_H_delay_cnt <= d2_H_delay_cnt + 1;
                d2_H_first_flag <= 1;
                
                if (d2_H_delay_cnt == DELAY_CYCLES) begin
                    d2_H_processing <= 1;
                end
            end        
        end
    end

/* Input flag */     
always@(posedge  sys_clk) 
    if(sys_rst == 0) begin
        d2_H_input_flag <= 0;
    end
    else if (d2_H_DWT_rst) begin
        d2_H_input_flag <= 1;
    end
    else if (d2_HH_row == H_SIZE-1 && d2_H_processing == 0) begin
        d2_H_input_flag <= 0;
    end
    else begin
        d2_H_input_flag <= d2_H_input_flag;
    end


/* Dim 2 High instance */ 
DWT_1D2L_for2D #(
    .SIZE(SIZE)
)
DWT_Dim2_H (
    .sys_clk(sys_clk),
    .sys_rst(sys_rst),
    .data_in(d2_H_data),
    .DWT_rst(d2_H_DWT_rst),
    
    .high_en(d2_H_high_en),
    .high_o(d2_H_high_o),
    .low_en(d2_H_low_en),
    .low_o(d2_H_low_o)
);

/* Output to HH and HL */ 
always@(posedge  sys_clk) begin
    if(sys_rst == 0) begin
        d2_HH_row <= 0;
        d2_HH_col <= 0;
        d2_HL_row <= 0;
        d2_HL_col <= 0;
        
        d2_high_over <= 0;
    end
    if (!d2_high_over) begin
        if (d2_HH_row <= H_SIZE && d2_HH_col <= H_SIZE) begin
            if (d2_H_high_en) begin
                HH[d2_HH_row][d2_HH_col] <= d2_H_high_o;
                if (d2_HH_row == H_SIZE-1) begin
                    d2_HH_col <= d2_HH_col + 1;
                    d2_HH_row <= 0;
                end
                else begin
                    d2_HH_row <= d2_HH_row + 1;
                end
            end
        end
        if (d2_HL_row <= L_SIZE && d2_HL_col <= H_SIZE) begin
            if (d2_H_low_en) begin
                HL[d2_HL_row][d2_HL_col] <= d2_H_low_o;
                if (d2_HL_row == L_SIZE-1) begin
                    d2_HL_col <= d2_HL_col + 1;
                    d2_HL_row <= 0;
                end
                else begin
                    d2_HL_row <= d2_HL_row + 1;
                end
            end
        end    
    end

    if (d2_HH_row == 0 && d2_HH_col == H_SIZE && d2_HL_row == 0 && d2_HL_col == H_SIZE) begin
        d2_high_over <= 1;
    end
end       
    
/* Dim 2 Low */
always@(posedge  sys_clk) 
    if(sys_rst == 0) begin
        low_row <= 0;
        low_col <= 0;
        d2_L_processing <= 1;
        d2_L_delay_cnt <= 0;
        d2_L_data <= 0;
        d2_L_DWT_rst <= 0;
        d2_L_first_flag <= 1;
        d2_L_line_cnt <= 0;    
    end    
    else begin
        if (d1_over) begin
            /* Input data to DWT_1D2L */
            if (d2_L_processing && !d2_low_over) begin
                
                if (d2_L_input_flag) begin
                    d2_L_data <= Low[low_row][low_col];
                    if (low_row == SIZE-1) begin
                        low_col <= low_col + 1;
                        low_row <= 0;
                    end
                    else begin
                        low_row <= low_row + 1;
                    end
                end
                else begin
                    d2_L_data <= Low[low_row][low_col];
                end
                
                
                if (d2_L_first_flag) begin
                    d2_L_DWT_rst <= 1;
                    d2_L_first_flag <= 0;
                end
                else begin                
                    d2_L_DWT_rst <= 0;
                end
               

                if (low_row == SIZE-1) begin
                    d2_L_processing <= 0;
                    d2_L_delay_cnt <= 0;
                    d2_L_line_cnt <= d2_L_line_cnt + 1;
                end
            end
            /* Delay mode */
            else begin 
                d2_L_data <= 0;
                d2_L_delay_cnt <= d2_L_delay_cnt + 1;
                d2_L_first_flag <= 1;
                
                if (d2_L_delay_cnt == DELAY_CYCLES) begin
                    d2_L_processing <= 1;
                end
            end        
        end
    end
    
/* Input flag */ 
always@(posedge  sys_clk) 
    if(sys_rst == 0) begin
        d2_L_input_flag <= 0;
    end
    else if (d2_L_DWT_rst) begin
        d2_L_input_flag <= 1;
    end
    else if (d2_LH_row == H_SIZE-1 && d2_L_processing == 0) begin
        d2_L_input_flag <= 0;
    end
    else begin
        d2_L_input_flag <= d2_L_input_flag;
    end

/* Dim 2 Low instance */ 
DWT_1D2L_for2D #(
    .SIZE(SIZE)
)
DWT_Dim2_L (
    .sys_clk(sys_clk),
    .sys_rst(sys_rst),
    .data_in(d2_L_data),
    .DWT_rst(d2_L_DWT_rst),
    
    .high_en(d2_L_high_en),
    .high_o(d2_L_high_o),
    .low_en(d2_L_low_en),
    .low_o(d2_L_low_o)
);

/* Output to LH and LL */ 
always@(posedge  sys_clk) begin
    if(sys_rst == 0) begin
        d2_LL_row <= 0;
        d2_LL_col <= 0;
        d2_LH_row <= 0;
        d2_LH_col <= 0;
        
        d2_low_over <= 0;
    end
    if (!d2_low_over) begin
        if (d2_LH_row <= H_SIZE && d2_LH_col <= L_SIZE) begin
            if (d2_L_high_en) begin
                LH[d2_LH_row][d2_LH_col] <= d2_L_high_o;
                if (d2_LH_row == H_SIZE-1) begin
                    d2_LH_col <= d2_LH_col + 1;
                    d2_LH_row <= 0;
                end
                else begin
                    d2_LH_row <= d2_LH_row + 1;
                end
            end
        end
        if (d2_LL_row <= L_SIZE && d2_LL_col <= L_SIZE) begin
            if (d2_L_low_en) begin
                LL[d2_LL_row][d2_LL_col] <= d2_L_low_o;
                if (d2_LL_row == L_SIZE-1) begin
                    d2_LL_col <= d2_LL_col + 1;
                    d2_LL_row <= 0;
                end
                else begin
                    d2_LL_row <= d2_LL_row + 1;
                end
            end
        end    
    end

    if (d2_LH_row == 0 && d2_LH_col == L_SIZE-1 && d2_LL_row == 0 && d2_LL_col == L_SIZE-1) begin
        d2_low_over <= 1;
    end
end       
    

endmodule