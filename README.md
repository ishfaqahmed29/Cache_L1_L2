# Cache_L1_L2
## This repo demonstrates the RTL Design of a Fully Associative, 32-Entry, Read-Only, Cache Memory Interface

![Untitled Workspace](https://user-images.githubusercontent.com/34355989/137039327-a4e9d75a-b4b3-47ab-b45f-8edef508b581.jpg)

## Specifications
- 32 Cache Lines, with Valid and Tag Blocks, that can store 32B wide data blocks
- Client_to_L1 Interface containing logic to request data from L1 Cache
- L1 to L2 Interface to send request in case of Cache MISS
- L2 to L1 Interface to send acknowledge to L1
- L1 to Client Interface to send acknowledge to Client

![image](https://user-images.githubusercontent.com/34355989/137039678-9ff27e47-170c-4687-b70d-03b43d1ec4bc.png)
Image Credits - [Dr Krste Asanovic](http://people.eecs.berkeley.edu/~krste/)
