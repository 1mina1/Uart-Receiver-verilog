// FILE NAME: RXFSM.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 20/7/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: UART RX controller, finite state machine, mealy state machine
//------------------------------------------------
// PURPOSE:   finite state machine act as controller for uart RX\
module RXFSM (
  input    wire    [2:0]    RXFSM_bit_cnt,
  input    wire             RXFSM_RX_IN,
  input    wire             RXFSM_par_err,
  input    wire             RXFSM_strt_glitch,
  input    wire             RXFSM_stp_err,
  input    wire             RXFSM_PAR_EN,
  input    wire             RXFSM_FINISH,
  input    wire             RXFSM_EdgeFinish,
  input    wire             RXFSM_CLK,
  input    wire             RXFSM_RST,
  output   reg              RXFSM_data_samp_en,
  output   reg              RXFSM_deser_en,
  output   reg              RXFSM_edge_cnt_enable,
  output   reg              RXFSM_bit_cnt_enable,
  output   reg              RXFSM_data_valid,
  output   reg              RXFSM_par_chk_en,
  output   reg              RXFSM_strt_chk_en,
  output   reg              RXFSM_stp_chk);
  
  /////////defining the states , gray encoding is used////////
  
  reg      [2:0]     Current_State;
  reg      [2:0]     Next_State;
  
  localparam IDLE       = 3'b000,
  Transmission_Start    = 3'b001,
  Transmission_Data     = 3'b011,
  Transmission_Parity   = 3'b010,
  Transmission_Stop     = 3'b110,
  Transmission_err      = 3'b111;
  
  /////////////////////state transition///////////////////
  always@(posedge RXFSM_CLK or negedge RXFSM_RST)
  begin
    if(!RXFSM_RST)
      Current_State <= IDLE ;
    else
      Current_State <= Next_State ;
  end
  //////////////////next state logic///////////////////
  always@(*)
  begin
    case(Current_State)
      IDLE                   : begin
                                if(~(RXFSM_RX_IN))
                                  begin
                                    Next_State = Transmission_Start;
                                  end
                                else
                                  begin
                                    Next_State = IDLE;
                                  end
                               end
      Transmission_Start    :  begin
                                if((RXFSM_strt_glitch))
                                  begin
                                    Next_State = IDLE;
                                  end
                                else if(RXFSM_EdgeFinish)
                                  begin
                                    Next_State = Transmission_Data;
                                  end
                                else
                                  begin
                                    Next_State = Transmission_Start;
                                  end
                               end
      Transmission_Data     :  begin
                                if(RXFSM_EdgeFinish & (&RXFSM_bit_cnt))
                                  begin
                                    if(RXFSM_PAR_EN)
                                      begin
                                        Next_State = Transmission_Parity;
                                      end
                                    else
                                      begin
                                        Next_State = Transmission_Stop;
                                      end
                                  end
                                else
                                  begin
                                    Next_State = Transmission_Data;
                                  end
                               end
      Transmission_Parity   :  begin
                                if(RXFSM_par_err)
                                  begin
                                    Next_State = Transmission_err;
                                  end
                                else if(RXFSM_EdgeFinish)
                                  begin
                                    Next_State = Transmission_Stop;
                                  end
                                else
                                  begin
                                    Next_State = Transmission_Parity;
                                  end
                               end
      Transmission_Stop     :  begin
                                if(RXFSM_stp_err)
                                  begin
                                    Next_State = Transmission_err;
                                  end
                                else if(RXFSM_FINISH)
                                  begin
                                    Next_State = IDLE;
                                  end
                                else
                                  begin
                                    Next_State = Transmission_Stop;
                                  end
                               end
      Transmission_err      : begin
                               if(RXFSM_EdgeFinish)
                                  begin
                                    Next_State = IDLE;
                                  end
                                else
                                  begin
                                    Next_State = Transmission_err;
                                  end
                              end
      default               :  begin
                                Next_State = IDLE;
                               end
    endcase
  end
  
  ////////////////////output logic////////////////////
  always@(*)
  begin
    case(Current_State)
      IDLE                   : begin
                                RXFSM_data_samp_en = 1'b0;
                                RXFSM_deser_en = 1'b0;
                                
                                RXFSM_bit_cnt_enable = 1'b0;
                                RXFSM_data_valid = 1'b0;
                                RXFSM_par_chk_en = 1'b0;
                                if(~(RXFSM_RX_IN))
                                  begin
                                   RXFSM_edge_cnt_enable = 1'b1;
                                  end
                                else
                                  begin
                                   RXFSM_edge_cnt_enable = 1'b0;
                                  end
                                RXFSM_strt_chk_en = 1'b0;
                                RXFSM_stp_chk = 1'b0; 
                               end
      Transmission_Start    :  begin
                                RXFSM_data_samp_en = 1'b1;
                                RXFSM_deser_en = 1'b0;
                                RXFSM_edge_cnt_enable = 1'b1;
                                RXFSM_bit_cnt_enable = 1'b0;
                                RXFSM_data_valid = 1'b0;
                                RXFSM_par_chk_en = 1'b0;
                                RXFSM_strt_chk_en = 1'b1;
                                RXFSM_stp_chk = 1'b0;                                
                               end
      Transmission_Data     :  begin
                                RXFSM_data_samp_en = 1'b1;
                                RXFSM_deser_en = 1'b1;
                                RXFSM_edge_cnt_enable = 1'b1;
                                RXFSM_bit_cnt_enable = 1'b1;
                                RXFSM_data_valid = 1'b0;
                                RXFSM_par_chk_en = 1'b0;
                                RXFSM_strt_chk_en = 1'b0;
                                RXFSM_stp_chk = 1'b0;                                 
                               end
      Transmission_Parity   :  begin
                                RXFSM_data_samp_en = 1'b1;
                                RXFSM_deser_en = 1'b0;
                                RXFSM_edge_cnt_enable = 1'b1;
                                RXFSM_bit_cnt_enable = 1'b0;
                                RXFSM_data_valid = 1'b0;
                                RXFSM_par_chk_en = 1'b1;
                                RXFSM_strt_chk_en = 1'b0;
                                RXFSM_stp_chk = 1'b0;   
                               end
      Transmission_Stop     :  begin
                                RXFSM_data_samp_en = 1'b1;
                                RXFSM_deser_en = 1'b0;
                                RXFSM_edge_cnt_enable = 1'b1;
                                RXFSM_bit_cnt_enable = 1'b0;
                                RXFSM_par_chk_en = 1'b0;
                                RXFSM_strt_chk_en = 1'b0;
                                RXFSM_stp_chk = 1'b1;
                                if(RXFSM_FINISH & ~(RXFSM_stp_err))
                                  begin
                                    RXFSM_data_valid = 1'b1;
                                  end
                                else
                                  begin
                                    RXFSM_data_valid = 1'b0;
                                  end
                               end
      Transmission_err      :  begin
                                RXFSM_data_samp_en = 1'b0;
                                RXFSM_deser_en = 1'b0;
                                RXFSM_edge_cnt_enable = 1'b1;
                                RXFSM_bit_cnt_enable = 1'b0;
                                RXFSM_data_valid = 1'b0;
                                RXFSM_par_chk_en = 1'b0;
                                RXFSM_strt_chk_en = 1'b0;
                                RXFSM_stp_chk = 1'b0;   
                               end
      default               :  begin
                                RXFSM_data_samp_en = 1'b0;
                                RXFSM_deser_en = 1'b0;
                                RXFSM_edge_cnt_enable = 1'b0;
                                RXFSM_bit_cnt_enable = 1'b0;
                                RXFSM_data_valid = 1'b0;
                                RXFSM_par_chk_en = 1'b0;
                                RXFSM_strt_chk_en = 1'b0;
                                RXFSM_stp_chk = 1'b0; 
                               end
    endcase
  end
  
endmodule