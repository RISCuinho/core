`define __TANGNANO__ TRUE
`define __GOWIN__    TRUE

// O QUE IMPORTA O ENDEREÇO, MAS O TAMANHO.
`define DBC_GPIO_ADDR_START 32'h05000000
`define DBC_GPIO_ADDR_END   32'h05000000

`include "MemoryMap.vh"

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
            output  reg[7:0] GPIO_D

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
   wire [`GPIO_WIDTH-1:0] local_gpio;

   AutoReset aRst(.clk(SYS_CLK), .count(35), .clr(SYS_RSTn), .rst(rst)); 
   RISCuin cpu(.clk(SYS_CLK), .rst(rst), .pc_end(LED_G), .gpio(local_gpio));

   assign LED_R = local_gpio[16];
//   assign LED_G = local_gpio[17];
   assign LED_B = local_gpio[18];

   always @(posedge SYS_CLK)begin
      if(!SYS_RSTn)begin
        GPIO_D <= local_gpio[7:0];
      end
   end

endmodule
