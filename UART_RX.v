// FILE NAME: UART_RX.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 22/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: uart reciever TX to RX
//------------------------------------------------
// PURPOSE:\top module for uart receiver\
module UART_RX (
  input    wire    [4:0]    UartRx_prescale,
  input    wire             UartRx_RX_IN,
  input    wire             UartRx_PAR_EN,
  input    wire             UartRx_Par_Type,
  input    wire             UartRx_CLK,
  input    wire             UartRx_RST,
  output   wire    [7:0]    UartRx_PDATA,
  output   wire             UartRx_Data_Valid);
  
  wire    [2:0]    bit_cnt;
  wire             edge_cnt_enable;
  wire             bit_cnt_enable;
  wire             EdgeFinish;
  wire    [4:0]    edge_cnt;
  wire             data_samp_en;
  wire             sample;
  wire             Sample_Valid;
  wire             strt_chk_en;
  wire             strt_glitch;
  wire             par_chk_en;
  wire             par_err;
  wire             deser_en;
  wire             stp_chk_en;
  wire             stp_err;
  wire             FINISH;
  //////////////////designs instantiations///////////////
  RXFSM U0_RXFSM(
  .RXFSM_bit_cnt(bit_cnt),
  .RXFSM_RX_IN(UartRx_RX_IN),
  .RXFSM_par_err(par_err),
  .RXFSM_strt_glitch(strt_glitch),
  .RXFSM_stp_err(stp_err),
  .RXFSM_PAR_EN(UartRx_PAR_EN),
  .RXFSM_FINISH(FINISH),
  .RXFSM_EdgeFinish(EdgeFinish),
  .RXFSM_CLK(UartRx_CLK),
  .RXFSM_RST(UartRx_RST),
  .RXFSM_data_samp_en(data_samp_en),
  .RXFSM_deser_en(deser_en),
  .RXFSM_edge_cnt_enable(edge_cnt_enable),
  .RXFSM_bit_cnt_enable(bit_cnt_enable),
  .RXFSM_data_valid(UartRx_Data_Valid),
  .RXFSM_par_chk_en(par_chk_en),
  .RXFSM_strt_chk_en(strt_chk_en),
  .RXFSM_stp_chk(stp_chk_en));
  
  edge_bit_counter U0_edge_bit_counter(
  .Cnt_prescale(UartRx_prescale),
  .Cnt_edge_cnt_enable(edge_cnt_enable),
  .Cnt_bit_cnt_enable(bit_cnt_enable),
  .Cnt_CLK(UartRx_CLK),
  .Cnt_RST(UartRx_RST),
  .Cnt_edge_cnt(edge_cnt),
  .Cnt_bit_cnt(bit_cnt),
  .Cnt_EdgeFinish(EdgeFinish));
  
  Data_Sampler U0_Data_Sampler(
  .Sampler_edge_cnt(edge_cnt),
  .Sampler_prescale(UartRx_prescale),
  .Sampler_data_samp_en(data_samp_en),
  .Sampler_RX_IN(UartRx_RX_IN),
  .Sampler_CLK(UartRx_CLK),
  .Sampler_RST(UartRx_RST),
  .Sampler_sample(sample),
  .Sampler_Sample_Valid(Sample_Valid));
  
  Deseralizer #(.WIDTH(8)) U0_Deseralizer(
  .Deseralizer_SampledData(sample),
  .Deseralizer_Sample_Valid(Sample_Valid),
  .Deseralizer_EN(deser_en),
  .Deseralizer_CLK(UartRx_CLK),
  .Deseralizer_RST(UartRx_RST),
  .Deseralizer_PDATA(UartRx_PDATA));
  
  Strt_Check U0_Strt_Check(
  .StrtChk_EN(strt_chk_en),
  .StrtChk_Sample_Valid(Sample_Valid),
  .StrtChk_sample(sample),
  .StrtChk_glitch(strt_glitch));
  
  Parity_Check #(.WIDTH(8)) U0_Parity_Check(
  .ParityCheck_PDATA(UartRx_PDATA),
  .ParityCheck_EN(par_chk_en),
  .ParityCheck_PAR_TYP(UartRx_Par_Type),
  .ParityCheck_sample(sample),
  .ParityCheck_Sample_Valid(Sample_Valid),
  .ParityCheck_Par_err(par_err));
  
  Stop_Check U0_Stop_Check(
  .StpChk_stp_chk_en(stp_chk_en),
  .StpChk_sample(sample),
  .StpChk_Sample_Valid(Sample_Valid),
  .StpChk_stp_err(stp_err),
  .StpChk_finish(FINISH));
  
endmodule
