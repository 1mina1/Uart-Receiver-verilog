// FILE NAME: UART_RX_tb.v
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
// PURPOSE:\test bench module for uart receiver\
`timescale 1ns/10ps
module UART_RX_tb();
  ///////////////////testbench signals////////////////
  reg    [4:0]    UartRx_prescale_tb;
  reg             UartRx_RX_IN_tb;
  reg             UartRx_PAR_EN_tb;
  reg             UartRx_Par_Type_tb;
  reg             UartRx_CLK_tb;
  reg             UartRx_RST_tb;
  reg             Transmitter_CLK;
  wire    [7:0]   UartRx_PDATA_tb;
  wire            UartRx_Data_Valid_tb;
  integer         Transmitted_enable;
  integer         Transmitted_data;
  integer         Transmitted_position;
  integer         counter;
  integer         Counter_fin;
  
  parameter  CLK_HALF_CYCLE =2.5;
   ////////////////////initial block///////////////////////
  initial 
   begin
    // Save Waveform
    $dumpfile("UART_RX.vcd") ;       
    $dumpvars;
    // initialization
    initialize();
    check_data();
    #500
    $finish;
   end
   ////////////////////signal initialization////////////////
 task initialize;
   begin
     UartRx_RST_tb  = 1'b0;
     UartRx_CLK_tb  = 1'b0;
     Transmitter_CLK = 1'b0;
     counter = 0;
     Counter_fin = 'd3;
     Transmitted_position = 0;
     Transmitted_data     ='b0;
     Transmitted_enable   = 0;
     #1
     UartRx_RST_tb = 1'b1;
   end
 endtask
  ////////////////////cheking recieved data////////////////////
  task check_data;
    begin
      //checking with parity enable for even and odd parity
      UartRx_prescale_tb  = 5'b00111;
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b0;
      Transmitted_position = 0;
      Transmitted_data     ='b10010101010;
      Transmitted_enable   = 1;
      #(177 * CLK_HALF_CYCLE)
      if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with even parity with prescelar 8");
        end
      else
        begin
          $display("data with even parity wasn't received with prescelar 8");
        end
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b1;
      Transmitted_position = 0;
      Transmitted_data     ='b11010101010;
      Transmitted_enable   = 1;
      #(176 *  CLK_HALF_CYCLE)
      if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with odd parity with prescelar 8");
        end
      else
        begin
          $display("data with odd parity wasn't received with prescelar 8");
        end
      UartRx_PAR_EN_tb    = 1'b0;
      Transmitted_position = 0;
      Transmitted_data     ='b1010101010;
      Transmitted_enable   = 1;
      #(160 * CLK_HALF_CYCLE)
      if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with no parity with prescelar 8");
        end
      else
        begin
          $display("data with no parity wasn't received with prescelar 8");
        end
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b0;
      Transmitted_position = 0;
      Transmitted_data     ='b00010101010;
      Transmitted_enable   = 1;
      #(176 *  CLK_HALF_CYCLE)
     if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b0)
        begin
          $display("stop checking is working");
        end
      else
        begin
          $display("stop checking isn't working");
        end
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b0;
      Transmitted_position = 0;
      Transmitted_data     ='b11010101010;
      Transmitted_enable   = 1;
      #(176 *  CLK_HALF_CYCLE)
     if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b0)
        begin
          $display("parity checking is working");
        end
      else
        begin
          $display("parity checking isn't working");
        end 
      UartRx_prescale_tb  = 5'b01111;
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b0;
      Transmitted_position = 0;
      Transmitted_data     ='b10010101010;
      Transmitted_enable   = 'd1; 
      counter              = 'd0;
      Counter_fin          = 'd7;
      #(354 * CLK_HALF_CYCLE)
       if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with even parity with prescelar 16");
        end
      else
        begin
          $display("data with even parity wasn't received with prescelar 16");
        end
       UartRx_prescale_tb  = 5'b01111;
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b1;
      Transmitted_position = 0;
      Transmitted_data     ='b11010101010;
      Transmitted_enable   = 'd1; 
      #(352 * CLK_HALF_CYCLE)
       if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with odd parity with prescelar 16");
        end
      else
        begin
          $display("data with odd parity wasn't received with prescelar 16");
        end
      UartRx_PAR_EN_tb    = 1'b0;
      UartRx_Par_Type_tb  = 1'b0;
      Transmitted_position = 0;
      Transmitted_data     ='b1010101010;
      Transmitted_enable   = 'd1; 
      #(320 * CLK_HALF_CYCLE)
       if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with no parity with prescelar 16");
        end
      else
        begin
          $display("data with no parity wasn't received with prescelar 16");
        end
      UartRx_prescale_tb  = 5'b11111;
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b0;
      Transmitted_position = 0;
      Transmitted_data     ='b10010101010;
      Transmitted_enable   = 'd1; 
      counter              = 'd0;
      Counter_fin          = 'd15;
      #(706 * CLK_HALF_CYCLE)
       if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with even parity with prescelar 32");
        end
      else
        begin
          $display("data with even parity wasn't received with prescelar 32");
        end
      UartRx_prescale_tb  = 5'b11111;
      UartRx_PAR_EN_tb    = 1'b1;
      UartRx_Par_Type_tb  = 1'b1;
      Transmitted_position = 0;
      Transmitted_data     ='b11010101010;
      Transmitted_enable   = 'd1; 
      #(704 * CLK_HALF_CYCLE)
       if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with odd parity with prescelar 32");
        end
      else
        begin
          $display("data with odd parity wasn't received with prescelar 32");
        end
      UartRx_prescale_tb  = 5'b11111;
      UartRx_PAR_EN_tb    = 1'b0;
      UartRx_Par_Type_tb  = 1'b1;
      Transmitted_position = 0;
      Transmitted_data     ='b1010101010;
      Transmitted_enable   = 'd1; 
      #(640 * CLK_HALF_CYCLE)
       if(UartRx_PDATA_tb == 8'b01010101 & UartRx_Data_Valid_tb == 1'b1)
        begin
          $display("data recieved successfully with no parity with prescelar 32");
        end
      else
        begin
          $display("data with no parity wasn't received with prescelar 32");
        end
    end
  endtask
  always@(posedge Transmitter_CLK)
  begin
    if(Transmitted_enable)
      begin
        if(Transmitted_position >= 'd11 )
          begin
            UartRx_RX_IN_tb <= 1'b1;
          end
        else
          begin
           UartRx_RX_IN_tb <= Transmitted_data[Transmitted_position];
          end
        Transmitted_position <= Transmitted_position + 1'b1;
      end
   else
     begin
       UartRx_RX_IN_tb <= 1'b1;
     end
  end
  always@(posedge UartRx_CLK_tb)//for 25 Mhz clock
  begin
    if(counter == Counter_fin)
      begin
        Transmitter_CLK <= !(Transmitter_CLK);
        counter <= 'd0; 
      end
    else
      begin
        counter <= counter+1;
      end
  end
  ////////////////////clock generation////////////////////
  always #CLK_HALF_CYCLE UartRx_CLK_tb  = !UartRx_CLK_tb;//for 200Mhz clock
  /////////////////// DUT Instantation ///////////////////
  UART_RX DUT(
  .UartRx_prescale(UartRx_prescale_tb),
  .UartRx_RX_IN(UartRx_RX_IN_tb),
  .UartRx_PAR_EN(UartRx_PAR_EN_tb),
  .UartRx_Par_Type(UartRx_Par_Type_tb),
  .UartRx_CLK(UartRx_CLK_tb),
  .UartRx_RST(UartRx_RST_tb),
  .UartRx_PDATA(UartRx_PDATA_tb),
  .UartRx_Data_Valid(UartRx_Data_Valid_tb));
endmodule