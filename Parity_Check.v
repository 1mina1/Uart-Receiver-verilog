// FILE NAME: Parity_Check.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 20/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: [parity check, odd even parity
//------------------------------------------------
// PURPOSE: \checking that the data received correctly by parity\
module Parity_Check #(parameter WIDTH = 8)(
  input    wire    [WIDTH-1:0]    ParityCheck_PDATA,
  input    wire                   ParityCheck_EN,
  input    wire                   ParityCheck_PAR_TYP,
  input    wire                   ParityCheck_sample,
  input    wire                   ParityCheck_Sample_Valid,
  output   reg                    ParityCheck_Par_err);
  
  reg    Parity_logic;
  reg    Parity;
  /////////////////Parity check combinational logic///////////////
  always@(*)
  begin
    if(ParityCheck_EN & ParityCheck_Sample_Valid )
      begin
        Parity_logic =^(ParityCheck_PDATA);
        if(ParityCheck_PAR_TYP)
          begin
           Parity = ~(Parity_logic);
          end
        else
          begin
           Parity = Parity_logic;
          end
        ParityCheck_Par_err = (Parity ^ ParityCheck_sample);
       end
    else
      ParityCheck_Par_err = 1'b0;
  end
endmodule
