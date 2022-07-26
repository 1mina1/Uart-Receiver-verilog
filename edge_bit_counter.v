// FILE NAME: edge_bit_counter.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 20/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: counter, edge counter , prescelar , sampling
//------------------------------------------------
// PURPOSE: \counting edge and number of bits for uart reciever\
module edge_bit_counter (
  input    wire     [4:0]     Cnt_prescale,
  input    wire               Cnt_edge_cnt_enable,
  input    wire               Cnt_bit_cnt_enable,
  input    wire               Cnt_CLK,
  input    wire               Cnt_RST,
  output   reg      [4:0]     Cnt_edge_cnt,
  output   reg      [2:0]     Cnt_bit_cnt,
  output   wire               Cnt_EdgeFinish);
  
  reg    [4:0]    EdgeCounter_comb;
  reg    [2:0]    BitCounter_comb;
  
  always@(posedge Cnt_CLK or negedge Cnt_RST) 
  begin
    if(!Cnt_RST)
      begin
        Cnt_edge_cnt <= 5'b0;
        Cnt_bit_cnt  <= 3'b0;
      end
    else
      begin
       Cnt_edge_cnt <= EdgeCounter_comb;
       Cnt_bit_cnt  <= BitCounter_comb;
      end
  end   
  //////////////////edge count logic///////////////
  always@(*)
  begin
    if(Cnt_edge_cnt_enable)
      begin
        if(Cnt_EdgeFinish)
          begin
            EdgeCounter_comb = 5'b0;
          end
        else
          begin
            EdgeCounter_comb = Cnt_edge_cnt + 5'b00001;
          end
      end
    else
      begin
        EdgeCounter_comb = 5'b0;
      end
  end
  assign Cnt_EdgeFinish = &(~(Cnt_edge_cnt ^ Cnt_prescale)); 
  /////////////////bit count logic////////////////
  always@(*)
  begin
    if(Cnt_bit_cnt_enable)
      begin
        if(Cnt_EdgeFinish)
          begin
            BitCounter_comb = BitCounter_comb + 3'b001;
          end
        else
          begin
            BitCounter_comb = Cnt_bit_cnt;
          end
      end
    else
      begin
        BitCounter_comb = 3'b0;
      end
  end
  
endmodule