# 7.16
1. 时序不对，subkey生成有问题，导致结果里含X -> fixed
2. 时序正常，但是结果输出有问题，还在分析中.
    - S1盒的地址写错了
    - IP逆置换写错了
    - ready逻辑写错了，最后不得不加一位寄存器保证在输出结果时ready为高