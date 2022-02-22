UART IP
==========================================

# Specification

## Message format

Structure:
- start bit
- data
- parity bit
- stop bit

|bit|0|1:8 |9 | 
|---|-|----|--|
|msg|0|data|1 |


## Synchronization

A mechanism to avoid issues due to asyncronous nature of the protocol:
 - Oversampling: 16 samples / bit. rx is probed at the middle (offset is 8).


## Communication speed
Baud rate


# API

## Receiver

```v
module uart_rx(input wire clk, input wire reset, input wire rx,
        output [7:0] data, output wire ready);
```

## Transmitter

TBA
