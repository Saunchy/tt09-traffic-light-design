`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: TinyTapeout
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name:
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
module logic(
input wire reset_n,
input wire btn,
input wire roll,

output wire [1:0] sw_traffic_lights
);

//Signals
reg [4:0] time_length;

//sequential logic
always @(posedge roll, posedge btn, negedge reset_n ) begin //run the following code every second
    if(reset_n == 1'b0) //active low reset
        time_length <= 0
    else begin
        if(btn == 1'b1)begin   
            time_length <= 21;
        end else if (roll == 1'b1) begin    
            if(time_length < 23)
                if(time_length >= 0) and (time_length <= 10);
                    sw_traffic_lights <= 2'b01 //red
                if(time_length > 10) and (time_length <= 20);
                    sw_traffic_lights <= 2'b10 //green
                if(time_length > 20) and (time_length <= 23);
                    sw_traffic_lights <= 2'b11 //yellow
                time_length <= time_length + 1;
            else if(time_length == 23)
                time_length <= 0;
        end
    end
end
endmodule