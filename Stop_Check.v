// FILE NAME: Stop_Check.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 22/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: stop checking, data error ,validation checking
//------------------------------------------------
// PURPOSE:   stop checking to make sure that data was sent successfully\
module Stop_Check (
  input    wire    StpChk_stp_chk_en,
  input    wire    StpChk_sample,
  input    wire    StpChk_Sample_Valid,
  output   reg     StpChk_stp_err,
  output   reg     StpChk_finish);
  
  //////////////////stop checking comb logic/////////////////
  always@(*)
  begin
    if(StpChk_stp_chk_en & StpChk_Sample_Valid)
      begin
        StpChk_stp_err = ~StpChk_sample;
        StpChk_finish  = 1'b1; 
      end
    else
      begin
        StpChk_stp_err = 1'b0;
        StpChk_finish  = 1'b0;
      end
  end
  
endmodule
