// FILE NAME: Deseralizer.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 22/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: Deseralizer serial in parrallel out
//------------------------------------------------
// PURPOSE: \this deseralizer is used to transform serial data 
// coming from data sampler to parallel data\
module Deseralizer #(parameter WIDTH =8)(
  input    wire                  Deseralizer_SampledData,
  input    wire                  Deseralizer_Sample_Valid,
  input    wire                  Deseralizer_EN,
  input    wire                  Deseralizer_CLK,
  input    wire                  Deseralizer_RST,
  output   reg    [WIDTH-1:0]    Deseralizer_PDATA);
  
  ///////////////////////Deseralizer logic////////////////
  always@(posedge Deseralizer_CLK or negedge Deseralizer_RST)
  begin
    if(!Deseralizer_RST)
      begin
        Deseralizer_PDATA <= 'b0;
      end
    else if(Deseralizer_Sample_Valid & Deseralizer_EN)
      begin
        Deseralizer_PDATA <= {Deseralizer_SampledData,Deseralizer_PDATA[WIDTH-1:1]};
      end
  end
  
endmodule