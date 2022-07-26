// FILE NAME: Data_Sampler.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 22/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: sampling data , latching , 3 samples
//------------------------------------------------
// PURPOSE: \this is a data sampler used for sampling data coming
// from uart tx with lower frequency, it takes 3 samples at the middle\
module Data_Sampler (
  input    wire    [4:0]   Sampler_edge_cnt,
  input    wire    [4:0]   Sampler_prescale,
  input    wire            Sampler_data_samp_en,
  input    wire            Sampler_RX_IN,
  input    wire            Sampler_CLK,
  input    wire            Sampler_RST,
  output   reg             Sampler_sample,
  output   reg             Sampler_Sample_Valid);
  
  wire           First_Sample;
  wire           Third_Sample;
  reg   [1:0]    Ones_Num;
  reg   [1:0]    Ones_Num_comb;
  reg            enable;
  ////////////////////sampler sequentional logic/////////////////
  always@(posedge Sampler_CLK or negedge Sampler_RST)
  begin
    if(!Sampler_RST)
      begin
        Ones_Num <= 2'b0;
      end
    else
      begin
       Ones_Num <= Ones_Num_comb;
      end
    end
  //////////////////sampler combinational logic/////////////////
  always@(*)
  begin
    if(Third_Sample & Sampler_data_samp_en)
      begin
        Ones_Num_comb = Ones_Num + Sampler_RX_IN;
        case(Ones_Num_comb)
          2'b10       : begin
                         Sampler_sample = 1'b1;
                        end
          2'b11       : begin
                         Sampler_sample = 1'b1;
                        end
          default     : begin
                         Sampler_sample = 1'b0;
                        end
          endcase
        Sampler_Sample_Valid = 1'b1;
        enable = 1'b0;
      end
    else if((First_Sample | enable) & Sampler_data_samp_en)
      begin
        Ones_Num_comb = Ones_Num + Sampler_RX_IN;
        Sampler_Sample_Valid = 1'b0;
        enable = 1'b1;
        Sampler_sample = 1'b0;
      end 
    else
      begin
        Ones_Num_comb = 2'b0;
        Sampler_Sample_Valid = 1'b0;
        enable = 1'b0;
        Sampler_sample = 1'b0;
      end
  end
  assign First_Sample  = &(~(Sampler_edge_cnt ^ (Sampler_prescale>>1)));
  assign Third_Sample  = &(~(Sampler_edge_cnt ^ ((Sampler_prescale>>1)+2'b10)));
endmodule
