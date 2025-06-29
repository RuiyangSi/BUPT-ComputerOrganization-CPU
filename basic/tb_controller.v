// tb_controller.v
// `timescale 定义了仿真时间和精度
`timescale 1ns / 1ps

module tb_controller;

    // --- 1. 声明信号，用于连接DUT ---
    // 用 reg 类型来驱动 DUT 的输入
    reg CLR_n;
    reg C, Z;
    reg [7:4] IR;
    reg [2:0] SW;
    reg T3;
    reg [2:0] W;

    // 用 wire 类型来接收 DUT 的输出
    wire LPC, PCINC, PCADD, LAR, ARINC, LIR, DRW, LDZ, LDC;
    wire [3:0] S;
    wire M, CIN;
    wire MEMW, ABUS, SBUS, MBUS;
    wire [3:0] SEL;
    wire SELCTL, STOP, SHORT, LONG;

    // --- 2. 实例化被测模块 (DUT: Device Under Test) ---
    controller uut (
        .CLR_n(CLR_n), .C(C), .Z(Z), .IR(IR), .SW(SW), .T3(T3), .W(W),
        .LPC(LPC), .PCINC(PCINC), .PCADD(PCADD), .LAR(LAR), .ARINC(ARINC), .LIR(LIR), .DRW(DRW), .LDZ(LDZ), .LDC(LDC),
        .S(S), .M(M), .CIN(CIN), .MEMW(MEMW), .ABUS(ABUS), .SBUS(SBUS), .MBUS(MBUS),
        .SEL(SEL), .SELCTL(SELCTL), .STOP(STOP), .SHORT(SHORT), .LONG(LONG)
    );

    // --- 3. 产生时钟信号 ---
    initial begin
        T3 = 0;
        forever #10 T3 = ~T3; // 每20ns一个周期
    end
    
    // --- 4. 编写测试序列 ---
    initial begin
        // --- 初始化和复位 ---
        $display("------ Simulation Start ------");
        CLR_n = 1'b0; // 施加复位
        SW = 3'b000;
        W = 3'b000;
        IR = 4'b0000;
        C = 0; Z = 0;
        #50;          // 等待50ns
        CLR_n = 1'b1; // 释放复位
        #50;

        // --- 测试场景1: 手动读存储器 (SW=010) ---
        $display("------ Test 1: READ_MEMORY ------");
        SW = 3'b010;
        // 第一次单步 (加载地址)
        W = 3'b001; #20; W = 3'b000; #20; // 模拟一次W1脉冲
        // 检查：此时STO应该翻转为1，SSTO=1, LAR=1等信号应该有效
        $display("After step 1: STO=%b, LAR=%b, SSTO=%b", uut.STO, LAR, uut.SSTO);
        
        // 第二次单步 (读取数据)
        W = 3'b001; #20; W = 3'b000; #20; // 模拟第二次W1脉冲
        // 检查：此时MBUS=1, ARINC=1等信号应该有效
        $display("After step 2: MBUS=%b, ARINC=%b", MBUS, ARINC);
        
        // --- 测试场景2: FETCH + ADD 指令 ---
        $display("------ Test 2: FETCH + ADD ------");
        SW = 3'b000; // 切换到运行模式
        IR = 4'b0001; // 设置指令为ADD
        // 模拟取指周期
        W = 3'b001; #20; // W1
        $display("FETCH W1: LIR=%b, PCINC=%b", LIR, PCINC);
        // 模拟执行周期
        W = 3'b010; #20; // W2
        $display("EXECUTE W2 (ADD): S=%h, DRW=%b", S, DRW);
        W = 3'b000; #20;

        // --- 在此添加更多的测试场景 ---
        // ... 测试所有手动模式 ...
        // ... 测试每一条指令 ...
        // ... 测试JC/JZ，需要手动设置C和Z的值 ...

        $display("------ Simulation End ------");
        $stop; // 结束仿真
    end

endmodule