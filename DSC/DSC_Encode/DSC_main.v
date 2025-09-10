//HDMI协议要处理的东西很多，所以先实现对一个图片的DSC编码

//想法是在转换时利用两个计数器计数像素组数，这样可以直接通过这个值得到是否是第一行、是否是每一行第一组等信息

module DSC_main(
    input                               clk                        ,
    input                               rst_n                      ,
    input [1:24]                 din_data_R                 ,
    input [1:24]                 din_data_G                 ,
    input [1:24]                 din_data_B                 ,
    input write_enable,//数据输入使能信号
    output data_init_ok,//可输入数据的信号
    output [1:48] write_data,//输出数据信号
    output [1:6] write_lenth,//最后一组数据的输出信号
    output slice_end,//标志slice中最后一组的信号
    output writeout_flag//标志输出数据的信号
);


//声明两个寄存器，使用这两个寄存器记录处理像素的组数和行数，这样就可以标识第一行和每行第一组
reg [1:10] pixel_group_count; //像素计数器,可以计数2^10*3 = 3072 > 1920，可以计算行内像素总数
reg [1:11] line_count; //行计数器，可以计数2^11 = 2048 > 1080，可以计算图像总行数                                                               





endmodule