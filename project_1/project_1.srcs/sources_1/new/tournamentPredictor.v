`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2025 07:17:08 PM
// Design Name: 
// Module Name: tournamentPredictor
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


module twoBitPredictor(
    input clk,
    input rst,
    input save_new_branch,
    input [31:0] branch_address,
    input [4:0] register,
    input [5:0] current_tag,
    input branch_outcome,
    output reg [31:0] saved_branch_address,
    output reg [4:0] saved_branch_register,
    output reg prediction,
    output reg [5:0] broadcast_bad_tag,
    output reg branch_not_taken_signal,
    output reg station_filled
    );

parameter strong_not_taken = 2'b00;
parameter weak_not_taken = 2'b01;
parameter weak_taken = 2'b10;
parameter strong_taken = 2'b11;
reg [1:0] state, next_state;
reg [5:0] saved_tag;


always@(posedge clk)begin 
    if(rst)begin
        state <= weak_not_taken;
        saved_branch_address <= 0;
        saved_branch_register <= 0;
        saved_tag <= 0;
        station_filled <= 0;
    end
    else
        state <= next_state;
end
always@(current_tag)begin
    saved_tag <= current_tag;
end
always@(*)begin 
    case(state)
        strong_not_taken: begin
            prediction <= 1'b0;
            if(branch_outcome == 1'b1)begin
                broadcast_bad_tag <= saved_tag;
                branch_not_taken_signal <= 1'b1;
            end
            else
                branch_not_taken_signal <= 1'b0;
        end
        weak_not_taken: begin 
            prediction <= 1'b0;
            if(branch_outcome == 1'b1)begin
                broadcast_bad_tag <= saved_tag;
                branch_not_taken_signal <= 1'b1;
            end
            else
                branch_not_taken_signal <= 1'b0;
        end
        weak_taken: begin 
            prediction <= 1'b1;
            if(branch_outcome == 1'b1)begin
                broadcast_bad_tag <= saved_tag;
                branch_not_taken_signal <= 1'b1;
            end
            else
                branch_not_taken_signal <= 1'b0;
        end
        strong_taken: begin
            prediction <= 1'b1;
            if(branch_outcome == 1'b1)begin
                broadcast_bad_tag <= saved_tag;
                branch_not_taken_signal <= 1'b1;
            end
            else
                branch_not_taken_signal <= 1'b0;
        end
    endcase
end

always@(*)begin 
    if(save_new_branch == 1'b1)begin
        saved_branch_address <= branch_address;
        saved_branch_register <= register;
        next_state <= weak_not_taken;
        station_filled <= 1;
    end
    else begin
    casez(state)
        strong_taken:begin
            if(branch_outcome == 1'b1) 
                next_state <= strong_taken;
            else if(branch_outcome == 1'b0)
                next_state <= weak_taken; 
            else if(branch_outcome <= 1'bz)
                next_state <= strong_taken;
            else 
                next_state <= strong_taken;
        end
        weak_taken: begin   
            if(branch_outcome == 1'b1)
                next_state <= strong_taken;
            else if(branch_outcome == 1'b0)
                next_state <= weak_not_taken;
            else if(branch_outcome <= 1'bz)
                next_state <= weak_taken;
            else 
                next_state <= weak_taken;
        end
        weak_not_taken: begin 
            if(branch_outcome == 1'b1)
                next_state <= weak_taken;
            else if(branch_outcome == 1'b0)
                next_state <= strong_not_taken;
            else if(branch_outcome <= 1'bz)
                next_state <= weak_not_taken;
            else 
                next_state <= weak_not_taken;
        end
        strong_not_taken: begin 
            if(branch_outcome == 1'b1)
                next_state <= weak_not_taken;
            else if(branch_outcome == 1'b0)
                next_state <= strong_not_taken;
            else if(branch_outcome <= 1'bz)
                next_state <= strong_not_taken;
            else 
                next_state <= strong_not_taken;
        end
    endcase
    end
end
        

endmodule
