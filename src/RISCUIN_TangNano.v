module RISCUIN_TangNano(
            // sys input
            input SYS_CLK,
            input SYS_RSTn,
            
            // LED interface
            output LED_R,
            output LED_G,
            output LED_B,

            // psram interface
            output PSRAM_CEn,
            output PSRAM_CLK,
            inout[3:0] PSRAM_SIO,

            // mcu interface
            //input MCU_SPI_SCLK,
            //input MCU_SPI_CS,
            //input MCU_SPI_MOSI,
            input MCU_REQ,
            output MCU_ACK,

            // Data
            output  reg[7:0] GPIO_D0
//            input   reg[3:0] GPIO_D1
            // LCD
            //output reg[4:0] LCD_R,
            //output reg[5:0] LCD_G,
            //output reg[4:0] LCD_B
            //output reg LCD_VSYNC,
            //output reg LCD_HSYNC,
            //output reg LCD_DEN,
            //output LCD_PCLK,
            //input LCD_BKL
);

	wire rst;

   AutoReset aRst(.clk(SYS_CLK), .count(35), .clr(SYS_RSTn), .rst(rst)); 
   RISCuin cpu(.clk(SYS_CLK), .rst(rst), .pc_end(LED_G));



endmodule
