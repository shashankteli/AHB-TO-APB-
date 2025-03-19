`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2025 14:11:39
// Design Name: 
// Module Name: Bridge_top
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
/////////////////////////////////////////////////////////////////

module Bridge_top (
  Hclk, Hresetn, Hwrite, Hreadyin, Hreadyout, Hwdata, Haddr, Htrans, Prdata,
  Penable, Pwrite, Pselx, Paddr, Pwdata, Hreadyout, Hresp, Hrdata
);

  // Port Declarations
  input Hclk, Hresetn, Hwrite, Hreadyin;
  input [31:0] Hwdata, Haddr, Prdata;
  input [1:0] Htrans;
  output Penable, Pwrite, Hreadyout;
  output [1:0] Hresp;
  output [2:0] Pselx;
  output [31:0] Paddr, Pwdata;
  output [31:0] Hrdata;

  ///////////////////////////////////////////////////////////////INTERMEDIATE SIGNALS
  wire valid;
  wire [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
  wire Hwritereg;
  wire [2:0] tempselx;

  // AHB Slave Interface instantiation
  AHB_SLAVE_INTERFACE AHBSlave_inst (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Htrans(Htrans),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Prdata(Prdata),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Hrdata(Hrdata),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Hresp(Hresp)
  );

  // APB Controller instantiation
  APB_controller APBControl_inst (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Prdata(Prdata),
    .Hwrite(Hwrite),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Pwrite(Pwrite),
    .Penable(Penable),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout)
  );

endmodule

