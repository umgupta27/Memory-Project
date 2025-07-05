module memory(clk_i,rst_i,addr_i,wdata_i,rdata_o,wr_rd_en_i,valid_i,ready_o);
//width=16; size=1kb
//depth=(1024*8)/16=512
/*clk=clock
rst= reset
addr=address
wdata=write data
rdata= read data
wr_rd_en=write:read:enable
valid = request
ready = acknowledge*/

//declaration of parameters
parameter WIDTH=8;
parameter DEPTH=16;
parameter ADDR_WIDTH=$clog2(DEPTH);//nothing but square root of width

//inputs decleration which has "_i" are called as input ports
input clk_i,rst_i,valid_i,wr_rd_en_i;
input [WIDTH-1:0] wdata_i;
input [ADDR_WIDTH-1:0] addr_i;

//outputs decleration which has "_o" are called as output ports
output reg [WIDTH-1:0] rdata_o;
output reg ready_o;

//memory decleration
reg [WIDTH-1:0] mem [DEPTH-1:0];
integer i;

always@(posedge clk_i)begin 
	if(rst_i) begin 
	rdata_o=0;
	ready_o=0;
	for (i=0;i<DEPTH;i=i+1)
	mem[i]=0;
	end
	else begin 
		if(valid_i)begin
				ready_o=1;
				if (wr_rd_en_i)begin 
				mem[addr_i]=wdata_i;
				end
				else begin 
					rdata_o=mem[addr_i];
				end
		end
		else begin 
			ready_o=0;
		end
	end

end
endmodule
/*Always Block:
1)Executes on the rising edge of the clock (clk_i).
2)If rst_i is high, it resets the memory (sets all locations to 0).
3)If valid_i is high:
	Sets ready_o to 1.
		If wr_rd_en_i is high, performs a write oper		ation (stores wdata_i at addr_i).
			Otherwise, performs a read operation				(loads data from addr_i into rdata_o).
If valid_i is low, sets ready_o to 0.*/

