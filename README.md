# Uart Receiver
this is the uart reciever done using verilog HDL it consists of the following block :  <br />
1-FSM(finite state machine)<br />
2-edge and bit counter<br />
3-data sampler<br />
4-deseralizer<br />
5-parity check<br />
6-start check <br />
7-stop check<br />

# FSM(finite state machine)
-the finite state machine is a mealy FSM that acts as a controller for the uart
# edge and bit counter
-the counter is used to count the edge or the bit the uart is currently receiving this helps in decision making for the FSM and the sampler as we take 3 samples from the middle<br /> 
-the uart receiver speed is faster than the uart transmitter and by how much faster it is configured by input prescaler and there is 3 options : <br />
1-the uart RX is faster 8 times.<br />
2-the uart RX is faster 16 times.<br />
3-the uart RX is faster 32 times.<br />
# data sampler
-from the edge count the data sampler takes 3 samples from the middle and take the most common value between them.<br />
# deseralizer
-receives the data from the sampler and transform it into a parrellel data.<br />
# parity check
-to check that the data is not corrupted.<br />
# start check 
-to check that there is no glitching that happened and a frame is being sent.<br />
# stop check
-to make sure that the stop bit is recieved correctly and data is not correctly.<br />
# excpected output 
-the output is expected to have the data received serially in the fram and data valid output for one clock cycle as soon that the receiver finish its check for stop and parity.<br />
