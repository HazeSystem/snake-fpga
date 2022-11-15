`include "hvsync_generator.v"
`include "sprite_bitmap.v"
`include "sprite_renderer.v"

module top(clk, reset, hsync, vsync, rgb, switches_p1, switches_p2);
  input clk, reset;
  input [7:0] switches_p1;
  input [7:0] switches_p2;
  output hsync, vsync;
  output [2:0] rgb;
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;
  
  logic [8:0] snake_x;
  logic [8:0] snake_y;
  
  localparam SNAKE_SIZE = 16;
  localparam SNAKE_SPEED = 5;

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );
  
  /*bit frame;  // high for one clock tick at the start of vertical blanking
  always_comb frame = (vpos == 240 && hpos == 0);*/
  
  always_ff @(posedge vsync) begin

  end
  
  always_ff @(posedge clk) begin
      
  end
  
  bit snake;
  
  always_comb begin
      snake_x = (256 / 2 - SNAKE_SIZE / 2);
      snake_y = (240 / 2 - SNAKE_SIZE / 2);      
      snake = (hpos >= snake_x) && (hpos < snake_x + SNAKE_SIZE)
      		&& (vpos >= snake_y) && (vpos < snake_y + SNAKE_SIZE);
  end

  // 
  wire r, g, b;
  always_comb begin
    if (snake) {r, g, b} = 3'b010;
    else {r, g, b} = 3'b000;
  end
  
  assign rgb = {b, g, r};

endmodule

/*module snake(buttons, x, y);
  input  buttons;
  output

endmodule*/