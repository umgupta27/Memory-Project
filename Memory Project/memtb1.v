`include "memory.v"
module tb;
	parameter WIDTH=16;
	parameter DEPTH=32;
	parameter ADDR_WIDTH=$clog2(DEPTH);

	reg clk_i,rst_i,valid_i,wr_rd_en_i;
	reg [WIDTH-1:0] wdata_i;
	reg [ADDR_WIDTH-1:0] addr_i;
	wire [WIDTH-1:0] rdata_o;
	wire ready_o;
	reg [WIDTH-1:0] mem [DEPTH-1:0];
	integer i;
memory #(.WIDTH(WIDTH),.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH)) dut(.*);
always begin 
	clk_i=0;#5;
	clk_i=1;#5;
end
initial begin 
	clk_i=0;rst_i=1;
	reset();
	#30;
	rst_i=0;
	write(0,DEPTH/4);
	read(0,DEPTH/2);
end
task reset();
begin 
	valid_i=0;
	wdata_i=0;
	addr_i=0;
	wr_rd_en_i=0;
end
endtask

task write(input reg [10:0]a,input reg [10:0]b);
begin
	for (i=a;i<a+b;i=i+1)begin 
		@(posedge clk_i);
		addr_i=i;
		wdata_i=$random;
		wr_rd_en_i=1;
		valid_i=1;
		wait(ready_o==1);
	end
	@(posedge clk_i);
		addr_i=0;
		wdata_i=0;
		wr_rd_en_i=0;
	valid_i=0;
end
endtask
task read(input reg [10:0]a,input reg [10:0]b);
begin
	for (i=a;i<a+b;i=i+1)begin
		@(posedge clk_i);
		addr_i=i;
		wr_rd_en_i=0;
		valid_i=1;
		wait(ready_o==1);
	end
		@(posedge clk_i);
		addr_i=0;
		wr_rd_en_i=0;
		valid_i=0;
end
endtask

initial #1000 $finish();
endmodule
