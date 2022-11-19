`include "hvsync_generator.v"
`include "sprite_bitmap.v"
`include "sprite_renderer.v"

module top(clk, reset, hsync, vsync, rgb, switches_p1, switches_p2);
  input clk, reset;
  input [7:0] switches_p1;
  input [7:0] switches_p2;
  output hsync, vsync;
  output [3:0] rgb;
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;
  
  logic [8:0] snake_x;
  logic [8:0] snake_y;
  logic [1:0] snake_d; //direction
  
  localparam SNAKE_SIZE = 8;
  localparam SNAKE_SPEED = 1;
  localparam HRES = 256;
  localparam VRES = 240;

  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );
  
  /*enum {NEW_GAME, PLAY} state, state_next;
  always_comb begin
        case (state)
            NEW_GAME: state_next = PLAY;
            PLAY: begin
            end
            default: state_next = NEW_GAME;
        endcase
        if (!clk_pix_locked) state_next = NEW_GAME;
    end

    // update game state
  always_ff @(posedge clk) state <= state_next;*/
  
  always_ff @(posedge vsync or posedge reset) begin
    if (reset) begin
      snake_x <= (HRES - SNAKE_SIZE) / 2;
      snake_y <= (VRES - SNAKE_SIZE) / 2;
      snake_d <= 1;
    end
        
    if 	    (switches_p1[0]) snake_d <= 0; //left arrow
    else if (switches_p1[1]) snake_d <= 1; //right arrow      
    else if (switches_p1[2]) snake_d <= 2; //up arrow
    else if (switches_p1[3]) snake_d <= 3; //down arrow      
    
    case (snake_d)
      0: begin
      	if (snake_x == 0) snake_x <= HRES - SNAKE_SIZE;
        else snake_x <= snake_x - SNAKE_SPEED;
      end
      1: begin
        if (snake_x == HRES - SNAKE_SIZE) snake_x <= 0;
        else snake_x <= snake_x + SNAKE_SPEED;
      end
      2: begin
        if (snake_y == 0) snake_y <= VRES - SNAKE_SIZE;
        else snake_y <= snake_y - SNAKE_SPEED;
      end
      3: begin
        if (snake_y == VRES - SNAKE_SIZE) snake_y <= 0;
        else snake_y <= snake_y + SNAKE_SPEED;
      end
    endcase
  end
  
  always_ff @(posedge clk or posedge reset) begin

  end
  
  bit snake;  
  always_comb begin
    snake = (hpos >= snake_x) && (hpos < snake_x + SNAKE_SIZE)
    && (vpos >= snake_y) && (vpos < snake_y + SNAKE_SIZE);
  end

  // 
  wire light, r, g, b;
  always_comb begin
    if (snake) {light, r, g, b} = 4'b0010;
    else {light, r, g, b} = 4'b0000;
  end
  
  assign rgb = {light, b, g, r};

endmodule