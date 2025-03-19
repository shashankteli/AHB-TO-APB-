`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.01.2025 13:19:50
// Design Name: 
// Module Name: AHB_SLAVE_INTERFACE
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


module AHB_SLAVE_INTERFACE(
input Hclk,
input Hresetn,
input Hwrite,
input Hreadyin,
input [1:0] Htrans,
input [31:0] Haddr,
input [31:0] Hwdata,
input [31:0] Prdata,
output [1:0] Hresp,
output [31:0] Hrdata,
output reg valid,
output reg [31:0] Haddr1,
output reg [31:0] Haddr2,
output reg [31:0] Hwdata1,
output reg [31:0] Hwdata2,
output reg Hwritereg,
output reg [2:0] tempselx
  );
  
  assign Hresp = 2'b00; 
  assign Hrdata = Prdata;
  
  always @(*)begin
    if(!Hresetn)
      valid = 1'b0;
    else if(Hreadyin && (Htrans==2'b11 || Htrans==2'b10) && (Haddr >= 32'h80000000 && Haddr < 32'h8c000000))
      valid = 1'b1;
    else 
      valid = 1'b0;
 end
 
  always @(*)begin
    if(Hresetn && Haddr >=32'h80000000 && Haddr < 32'h84000000)
      tempselx = 3'b001;
    else if(Hresetn && Haddr >=32'h84000000 && Haddr < 32'h88000000)
      tempselx = 3'b010;
    else if(Hresetn && Haddr >=32'h88000000 && Haddr < 32'h8c000000)
      tempselx = 3'b100;
    else tempselx = 3'b000;
    
 end  
 
  always @(posedge Hclk)begin
    if(!Hresetn)begin
       Haddr1 <= 32'b0;
       Haddr2 <= 32'b0;
     end
     else 
     begin
       Haddr1 <= Haddr;
       Haddr2 <= Haddr1;
     end
   end    
   
   always @(posedge Hclk)begin
    if(!Hresetn)begin
       Hwdata1 <= 32'b0;
       Hwdata2 <= 32'b0;
     end
     else 
     begin
       Hwdata1 <= Hwdata;
       Hwdata2 <= Hwdata1;
     end
   end  
   
    always @(*)begin
    if(!Hresetn)
      Hwritereg <= 1'b0;
    else 
      Hwritereg <= Hwrite;
 end                
             
            
endmodule
