`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2025 09:57:10
// Design Name: 
// Module Name: APB_controller
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


module APB_controller(
input Hclk,
input Hresetn,
input [31:0] Haddr,
input [31:0] Hwdata,
input valid,
input [31:0] Haddr1,
input [31:0] Haddr2,
input [31:0] Hwdata1,
input [31:0] Hwdata2,
input Hwritereg,
input [2:0] tempselx,
input Hwrite,
input [31:0] Prdata,
output reg Hreadyout,
output reg Pwrite,
output reg Penable,
output reg [2:0] Pselx,
output reg [31:0] Pwdata,
output reg [31:0] Paddr

    );
    
    parameter ST_IDLE=3'b000,
              ST_WWAIT=3'b001,
              ST_WRITEP=3'b010,
              ST_WENABLEP=3'b011,
              ST_WRITE=3'b100,
              ST_WENABLE=3'B101,
              ST_RENABLE=3'b110,
              ST_READ=3'b111;
              
    reg [2:0] present_state,next_state;
    
    // present state logic
    always @(posedge Hclk)begin
       if(!Hresetn)
         present_state <= ST_IDLE;
       else
         present_state <= next_state;
     end
     
     //next state logic
     
    always @(*)begin
      case(present_state)
         ST_IDLE:begin 
                  if(valid && Hwrite)
                    next_state = ST_WWAIT;
                  else if(valid && ~Hwrite)
                    next_state = ST_READ;
                  else
                    next_state = ST_IDLE;
                  end  
                    
         ST_WWAIT:begin 
                   if(valid)
                     next_state = ST_WRITEP;
                   else
                     next_state = ST_WRITE;
                  end   
                     
         ST_WRITEP: begin
                     next_state = ST_WENABLEP;
                    end 
         ST_WRITE: begin
                   if(valid)
                     next_state = ST_WENABLEP;
                   else
                     next_state = ST_WENABLE;
                   end  
                     
         ST_WENABLEP: begin
                       if(valid && Hwritereg)
                        next_state = ST_WRITEP;
                       else if(~valid && Hwritereg)
                        next_state = ST_WRITE;
                       else 
                        next_state = ST_READ; 
                      end    
                       
         ST_WENABLE: begin 
                       if(~valid)
                        next_state = ST_IDLE;
                       else if(valid && Hwrite)
                        next_state = ST_WWAIT;
                       else
                        next_state = ST_READ;
                     end  
                    
                        
         ST_RENABLE: begin  
                       if(~valid)
                        next_state = ST_IDLE; 
                       else if(valid && Hwrite)
                        next_state = ST_WWAIT;
                       else
                        next_state = ST_READ;
                     end   
                      
                        
          ST_READ:begin    
                      next_state = ST_RENABLE;
                  end
                  
          default: begin
                     next_state = ST_IDLE;
                   end              
          
     endcase
   end  
   
// output logic   
reg Penable_temp,Hreadyout_temp,Pwrite_temp;
reg [2:0] Pselx_temp;
reg [31:0] Paddr_temp, Pwdata_temp;

always @(*)
 begin:OUTPUT_COMBINATIONAL_LOGIC
   case(present_state)
    
	ST_IDLE: begin
			  if (valid && ~Hwrite) 
			   begin:IDLE_TO_READ
			        Paddr_temp=Haddr;
				    Pwrite_temp=Hwrite;
				    Pselx_temp=tempselx;
				    Penable_temp=0;
				    Hreadyout_temp=0;
			   end
			  
			  else if (valid && Hwrite)
			   begin:IDLE_TO_WWAIT
			        Pselx_temp=0;
				    Penable_temp=0;
				    Hreadyout_temp=1;			   
			   end
			   
			  else
               begin:IDLE_TO_IDLE
			         Pselx_temp=0;
				     Penable_temp=0;
				     Hreadyout_temp=1;	
			   end
		     end    

	ST_WWAIT:begin
	          if (~valid) 
			   begin:WAIT_TO_WRITE
			         Paddr_temp=Haddr1;
				     Pwrite_temp=1;
				     Pselx_temp=tempselx;
				     Penable_temp=0;
				     Pwdata_temp=Hwdata;
				     Hreadyout_temp=0;
			   end
			  
			  else 
			   begin:WAIT_TO_WRITEP
			         Paddr_temp=Haddr1;
				     Pwrite_temp=1;
				     Pselx_temp=tempselx;
				     Pwdata_temp=Hwdata;
				     Penable_temp=0;
				     Hreadyout_temp=0;		   
			   end
			   
		     end  

	ST_READ: begin:READ_TO_RENABLE
			       Penable_temp=1;
			       Hreadyout_temp=1;
		     end

	ST_WRITE:begin
              if (~valid) 
			   begin:WRITE_TO_WENABLE
				     Penable_temp=1;
				     Hreadyout_temp=1;
			   end
			  
			  else 
			   begin:WRITE_TO_WENABLEP ///DOUBT
				     Penable_temp=1;
				     Hreadyout_temp=1;		   
			   end
		     end

	ST_WRITEP:begin:WRITEP_TO_WENABLEP
                    Penable_temp=1;
			        Hreadyout_temp=1;
		      end

	ST_RENABLE:begin
	            if (valid && ~Hwrite) 
				 begin:RENABLE_TO_READ
					   Paddr_temp=Haddr;
					   Pwrite_temp=Hwrite;
					   Pselx_temp=tempselx;
					   Penable_temp=0;
					   Hreadyout_temp=0;
				 end
			  
			  else if (valid && Hwrite)
			    begin:RENABLE_TO_WWAIT
			          Pselx_temp=0;
				      Penable_temp=0;
				      Hreadyout_temp=1;			   
			    end
			   
			  else
                begin:RENABLE_TO_IDLE
			          Pselx_temp=0;
				      Penable_temp=0;
				      Hreadyout_temp=1;	
			    end

		       end

	ST_WENABLEP:begin
                 if (~valid && Hwritereg) 
			      begin:WENABLEP_TO_WRITEP
			            Paddr_temp=Haddr2;
				        Pwrite_temp=Hwrite;
				        Pselx_temp=tempselx;
				        Penable_temp=0;
				        Pwdata_temp=Hwdata;
				        Hreadyout_temp=0;
				  end

			  
			    else 
			     begin:WENABLEP_TO_WRITE_OR_READ /////DOUBT
			           Paddr_temp=Haddr2;
				       Pwrite_temp=Hwrite;
				       Pselx_temp=tempselx;
				       Pwdata_temp=Hwdata;
				       Penable_temp=0;
				       Hreadyout_temp=0;		   
			     end
		        end

	ST_WENABLE :begin
	             if (~valid && Hwritereg) 
			      begin:WENABLE_TO_IDLE
				        Pselx_temp=0;
				        Penable_temp=0;
				        Hreadyout_temp=0;
				  end

			  
			    else 
			     begin:WENABLE_TO_WAIT_OR_READ /////DOUBT
				       Pselx_temp=0;
				       Penable_temp=0;
				       Hreadyout_temp=0;		   
			     end

		        end

 endcase
end


////////////////////////////////////////////////////////OUTPUT LOGIC:SEQUENTIAL

always @(posedge Hclk)
 begin
  
  if (~Hresetn)
   begin
    Paddr<=0;
	Pwrite<=0;
	Pselx<=0;
	Pwdata<=0;
	Penable<=0;
	Hreadyout<=0;
   end
  
  else
   begin
    Paddr<=Paddr_temp;
	Pwrite<=Pwrite_temp;
	Pselx<=Pselx_temp;
	Pwdata<=Pwdata_temp;
	Penable<=Penable_temp;
	Hreadyout<=Hreadyout_temp;
   end
  end
endmodule
