// FILE NAME: Strt_Check.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 20/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: start checking, glitch
//------------------------------------------------
// PURPOSE:   start checking to make sure there is no glitch\
module Strt_Check (
 input    wire    StrtChk_EN,
 input    wire    StrtChk_Sample_Valid,
 input    wire    StrtChk_sample,
 output   reg     StrtChk_glitch);

///////////////////start checking combinational logic/////////////////
 always@(*)
 begin
   if(StrtChk_EN & StrtChk_Sample_Valid)
     begin
       StrtChk_glitch = StrtChk_sample;
     end
   else
     begin
       StrtChk_glitch = 1'b0;
     end
 end
endmodule
