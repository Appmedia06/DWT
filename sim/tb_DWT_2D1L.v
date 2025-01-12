`timescale 1ns/1ps

module tb_DWT_2D1L;
    reg              sys_clk;
    reg              sys_rst;
    
    wire             d1_over_o;
    wire             d2_high_over_o;
    wire             d2_low_over_o;
    
    reg     [2:0]    display;
    
    DWT_2D1L DWT_2D1L
    (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        
        .d1_over_o     (d1_over_o),
        .d2_high_over_o(d2_high_over_o),
        .d2_low_over_o (d2_low_over_o)
    );

    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end


    initial begin        
        sys_rst = 0;
        display <= 3'b111;

        #10 sys_rst = 1;

        #2000;
    end

    always @(posedge sys_clk) begin
        if (d1_over_o && display[0]) begin
            display[0] <= 0;
            $display("Dim 1 has been completed at time %0t", $time);
        end
        if (d2_low_over_o && display[1]) begin
            display[1] <= 0;
            $display("Dim 2 Low has been completed at time %0t", $time);  
        end
        if (d2_high_over_o && display[2]) begin
            display[2] <= 0;
            $display("Dim 2 High has been completed at time %0t", $time);
            $display("        ,@@@@@@@@@@,,@@@@@@@&  .#&@@@&&.,@@@@@@@@@@,      &@@@@@@&*   ,@@@&     .#&@@@&&.  *&@@@@&(  ,@@@@@@@&  &@@@@@,     ,@@,");
            $display("            ,@@,    ,@@,      ,@@/   ./.    ,@@,          &@&   ,&@# .&@&@@(   .@@/   ./. #@&.  .,/  ,@@,       &@&  *&@&.  ,@@,");
            $display("            ,@@,    ,@@&&&&&. .&@@/,        ,@@,          &@&   ,&@# &@& /@@,  .&@@/,     (@@&&(*.   ,@@&&&&&.  &@&    &@#  ,@@,");
            $display("            ,@@,    ,@@&&&&&. .&@@/,        ,@@,          &@&   ,&@# &@& /@@,  .&@@/,     (@@&&(*.   ,@@&&&&&.  &@&    &@#  ,@@,");
            $display("            ,@@,    ,@@/,,,,    ./#&@@@(    ,@@,          &@@@@@@&* /@@,  #@&.   ./#&@@@(   *(&&@@&. ,@@/,,,,   &@&    &@#  .&&.");
            $display("            ,@@,    ,@@,      ./,   .&@#    ,@@,          &@&      ,@@@@@@@@@& ./.   .&@# /*.   /@@. ,@@,       &@&  *&@&.   ,, ");
            $display("            ,@@,    ,@@@@@@@& .#&@@@@&/     ,@@,          &@&     .&@#     ,@@/.#&@@@@&/   /&&@@@@.  ,@@@@@@@&  &@@@@@.     ,@@,");
            $display(",*************,,*/(((((//,,*(#&&&&&&&&&&&&&&&#(*,,,****************************************************,*/(((((((((/((((////****/((##&&&&&&");
            $display(",*************,,//((((((//,,*(&&&&&&&&&&&&&&&&&##/*****************************************************,,*/(///(//////****//((##&&&&&&&&&&&");
            $display(",************,,*/(((((((//***/#&&&&&&&&&&&&&&&&&&&#(/***************************************************,*//////////*//((#&&&&&&&&&&&&&&&&&");
            $display(",***********,,*////////////***/##&&&&&&&&&&&&&&&&&&&##(*,***********************************************,,*////////(###&&&&&&&&&&&&&&&&&&&&");
            $display(",**********,,,*/*******//////**/(#&&&&&&&&&&&&&&&&&&&&&#(/**********************************************,,,***/(##&&&&&&&&&&&&&&&&&&&&&&&&&");
            $display(",*********,,,,*************///***/(#&&&&&&&&&&&&&&&&&&&&&&#(/***********************************,****,****/((#&&&&&&&&&&&&&&&&&&&&&&&&&&&&#");
            $display(",*********,,,***************//****/(##&&&&&&&&&&&&&&&&&&&&&&##//**************//////////////////////((#####&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(");
            $display(",********,,,,***********************/(#&&&&&&&&&&&&&&&&&&&&&&&##################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##(/");
            $display(",*******,..,***********************,,*/##&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&###((//");
            $display(",*******,.,,***********************,,,,*(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##(//**//");
            $display(",******,.,,,************************,,,,*/(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(//*******");
            $display(",*****,,,,,********,***,,,,,,,,,,,,*,,,,,,*/(######&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##(/**********");
            $display(",*****,..,*******,,,,,,,,,,,,,,,,,,,,,,*,,,,*///((#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&###(/************");
            $display(",*****,,,*******,,,,,*,,,,,,,,,,,,,,,,,****,,,*/(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#######(//**************");
            $display(",****,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,**,,,/(&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#((//******************");
            $display(",***,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..,,,,,,,*(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(/*******************");
            $display(",**,,.,,,,,,,,,,,,,,,,,,,,,,,,,,.......,,,,,,/#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#####&&&&&&&&&&&&&&&&#(/******************");
            $display(",**,..,,,,,,,,,,,,,,,,,,,,,,,,,......,,,*,,,*(#&&&&&&&&##(((/(##&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##(((/*/((#&&&&&&&&&&&&&&#(/*****************");
            $display(",*,..,,,,,,,,,,,,,,,,,,,,,,,,,,,.....,,**,,*/#&&&&&&&##((((*,**/#&&&&&&&&&&&&&&&&&&&&&&&&&&&&##((##/,,,*(#&&&&&&&&&&&&&&#(*****************");
            $display(".*,.,,,**,,,,,,,,,,,,,,,,,,,,,,,,,,*****,,,/(&&&&&&&&#(//(#/,..*/#&&&&&&&&&&&&&&&&&&&&&&&&&&&#(//(#/,..,/(#&&&&&&&&&&&&&&#/*****///////////");
            $display(".,..,,,,,,,,,,,,,,,,,,,,,,,,,,*,,*******,,,(#&&&&&&&&#(*,,,....,/#&&&&&&&&&&&&&&&&&&&&&&&&&&&#(*,,,....,/(#&&&&&&&&&&&&&&#(*,**////////////");
            $display(".,..,,,,,,,,,...........,,,,,,*,********,,*(#&&&&&&&&&#(/*,,...,/#&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(/*,,..,*/##&&&&&&&&&&&&&&&#(***////////////");
            $display(" ..,,,,,,.................,,,**********,,*(#&&&&&&&&&&&&&&&&&&#&&&&&&&&#((///((#&&&&&&&&&&&&&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&&#/**////////////");
            $display(".,,,,,,,,.................,,***********,,/(####&&&&&&&&&&&&&&&&&&&&&&&&#(/*,,,*(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(/*////////////");
            $display(".,***,,,,,,..............,,,**********,..,***//((##&&&&&&&&&&&&&&&&&&&&&&&##((##&&&&&&&&&&&&&&&&&&&&&&&&&##(((((((((###&&&&&#/**///////////");
            $display(".*****,,,,,,,,,,,,,,,,,,,*************,..,*******/(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##///*//////((#&&&&&#(**///////////");
            $display(".****************/******/***////*****,.,*///////**/#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(////////////(#&&&&&#/**//////////");
            $display(".***********************/////*******,..,*//////////(#&&&&&&&&&&&&&&&&&&&&##########&&&&&&&&&&&&&&&&&&&&#(///////////*/(#&&&&&#(***/////////");
            $display(".************************///********,..,*//////////#&&&&&&&&&&&&&&&&&&#(//*****///(((##&&&&&&&&&&&&&&&&#(///////////**/##&&&&##/***////////");
            $display(".***********************************,.,,***///////(#&&&&&&&&&&&&&&&&#(/*,,,*//((((////(#&&&&&&&&&&&&&&&#((////////////(#&&&&&&#(*********//");
            $display(",***********,,,*,,*,,**************,,,*//******//(#&&&&&&&&&&&&&&&&&#(*,,*/(((#####(((((#&&&&&&&&&&&&&&&##///////////(#&&&&&&&&#(***///////");
            $display(",*************,,**,,,************,,,,,/(##((((####&&&&&&&&&&&&&&&&&&&(/**/(((#((((#((//(#&&&&&&&&&&&&&&&&&#(((((((((##&&&&&&&&&&#/**///////");
            $display(",******************************,,,,,,,*(#&#&&&&&&&&&&&&&&&&&&&&&&&&&&#(**/((#(#(((#((//(#&&&&&&&&&&&&&&&&&&&&&&&#&#&&&&&&&&&&&&&#(**///////");
            $display(",*************,**************,****,,,,,/(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(/*/((((#((((///(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&(/*///////");
            $display(",*************************************,*/#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##(////////////(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#/**/////*");
            $display(",******////****///////////////////////***/#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&####(((((((###&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(********");
            $display(".,*,****///////////////////////////////***/#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#(/*******");
            $display(".,,,,*****//////////////////////////*******(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##(*******");
            $display(".,,,,,,***********/////////////////********/(#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&(*******");
            $display("=========================================");
            $finish;     
        end
    end

endmodule
