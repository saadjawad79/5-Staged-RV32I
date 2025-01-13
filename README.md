# Implementation of RV32I Processor  

- All RV32I Base ISA instructions implemented
- Fully Pipelined at 5 stages (IF, ID, EX, MEM, WB)
- Hazard Detection unit for detecting data hazards i.e. Read after Write (RAW) Hazards
- Forwarding and Stalling when appropriate to counter RAW hazards
- Static Branch Prediction via Lookup Table
