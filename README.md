# UART-Receiver

Universal Asynchronous Receiver Transmitter (UART) protocol transforms parallel data into serial format.

When designing a UART receiver, we need to consider sampling using a higher frequency to determine the start of the incoming UART frame, in the case of UART receiver, a sampling signal that 16 times the baud rate is usually used by the receiver, once the receiver detects the start of a UART frame, it waits for 8 clock periods to sample the middle of the incoming bit (to make sure it is not a glitch). Then, we can now sample the incoming data every 16 clock periods.
