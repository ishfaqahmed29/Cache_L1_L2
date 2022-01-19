# Cache_L1_L2
## This repo demonstrates the RTL Design of a Fully Associative, 32-Entry, Read-Only, Cache Memory Interface

![Untitled Workspace](https://user-images.githubusercontent.com/34355989/137039327-a4e9d75a-b4b3-47ab-b45f-8edef508b581.jpg)

## Specifications
- 32 Cache Lines, with Valid and Tag Blocks, that can store 32B wide data blocks from main memory
- Client_to_L1 Interface containing logic to REQ data from L1 Cache
- L1_to_L2 Interface to send REQ to L2 when Cache MISS
- L2_to_L1 Interface to send ACK to L1
- L1_to_Client Interface to send ACK to Client

![image](https://user-images.githubusercontent.com/34355989/137039678-9ff27e47-170c-4687-b70d-03b43d1ec4bc.png)
Image Credits - [Dr Krste Asanovic](http://people.eecs.berkeley.edu/~krste/)
