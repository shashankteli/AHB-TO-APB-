`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2025 15:33:07
// Design Name: 
// Module Name: AHB_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AHB_master(
input Hclk,
input Hresetn,
input Hreadyout,
input [31:0] Hrdata,
output reg [31:0] Haddr,
output reg [31:0] Hwdata,
output reg Hwrite,Hreadyin,
output reg [1:0] Htrans
);

reg [2:0] Hburst;
reg [2:0] Hsize;

integer i,j;

// single write
task single_write();
  begin
    @(posedge Hclk)
      #5;
    begin
      Hwrite = 1;
      Htrans = 2'd2;
      Hsize = 0;
      Hburst = 0;
      Hreadyin = 1;
      Haddr = 32'h80000001;
     end
     
     @(posedge Hclk)
       #5;
     begin
       Htrans = 2'd0;
       Hwdata = 8'h80;
     end
   end
 endtask
 
 // single read
 task single_read();
   begin
    @(posedge Hclk)
    begin
      Hwrite = 0;
      Htrans = 2'd2;
      Hsize = 0;
      Hburst = 0;
      Hreadyin = 1;
      Haddr = 32'h80000001;
     end
     
     @(posedge Hclk)
      #5;
     begin
      Htrans = 2'd0;
     end
    end
  endtask
  
  // Burst write
  task burst_write();
    begin
     @(posedge Hclk)
      #5;
     begin
      Hwrite = 1'b1;
      Htrans = 2'd2;
      Hsize = 0;
      Hburst = 3'd3;
      Hreadyin = 1;
      Haddr = 32'h80000001;
     end
     @(posedge Hclk)
       #5;
     begin
       Haddr = Haddr + 1'b1;
       Hwdata = {$random}%256;
       Htrans = 2'd3;    
      end
      
for(i=0;i<2;i=i+1)
begin
  @(posedge Hclk)
  #1;
  Haddr = Haddr + 1;
  Hwdata = {$random}%256;
  Htrans = 2'd3;
 end
 
  @(posedge Hclk)
  #1;
  begin
  Hwdata = {$random}%256;
  Htrans = 2'd0;
  end
 end
endtask         
             
            

endmodule
