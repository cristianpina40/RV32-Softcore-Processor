`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module reservationStationInteger #(parameter reg_index = 4, phys_index = 5, opcode_size = 6, tag_size = 5)(
    input [phys_index: 0] finished_phys_reg1,
    input [phys_index: 0] finished_phys_reg2,
    input [phys_index: 0] finished_phys_reg3,
    input [tag_size: 0] finished_tag,
    input [tag_size: 0] input_tag,
    input [opcode_size: 0] operation_in,
    input [phys_index: 0] reg_address1_in,
    input [phys_index: 0] reg_address2_in,
    input valid_reg1,
    input valid_reg2,
    output reg [phys_index: 0] reg_address1_out,
    output reg [phys_index: 0] reg_address2_out,
    output reg [tag_size: 0] output_tag,
    output reg [opcode_size: 0] operation_out
);

localparam station_amount = 7;
integer i;
reg [tag_size: 0] tag_memory [station_amount: 0];
reg [opcode_size: 0] op_memory [station_amount: 0];
reg [phys_index: 0] address1_memory [station_amount: 0];
reg [phys_index: 0] address2_memory [station_amount: 0];
reg [station_amount: 0] valid1_memory;
reg [station_amount: 0] valid2_memory;
reg [3:0] station_index;
reg [station_amount: 0] station_free;

initial begin 
    station_index = 0;
    for(i = 0; i <= station_amount; i = i + 1)begin 
        tag_memory[i] <= 0;
        op_memory[i] <= 0;
        address1_memory[i] <= 0;
        address2_memory[i] <= 0;
        valid1_memory[i] <= 0;
        valid2_memory[i]<= 0;
        station_free[i] <= 0;
    end
end


always@(input_tag)begin 
    tag_memory[station_index] <= input_tag;
    op_memory[station_index] <= operation_in;
    address1_memory[station_index] <= reg_address1_in;
    address2_memory[station_index] <= reg_address2_in;
    valid1_memory[station_index] <= valid_reg1;
    valid2_memory[station_index] <= valid_reg2; 
    station_free[station_index] <= 1'b0;
    station_index = station_index + 1; 
end

always@(finished_phys_reg1)begin 
    for(i = 0; i <= station_amount; i = i + 1)begin
        if((address1_memory[i] == finished_phys_reg1) && valid1_memory[i] == 1'b0)
            valid1_memory[i] <= 1'b1;
        else 
            valid1_memory[i] <= valid1_memory[i];
    end
    for(i = 0; i <= station_amount; i = i + 1)begin
        if((address2_memory[i] == finished_phys_reg1) && valid2_memory[i] == 1'b0)
            valid2_memory[i] <= 1'b1;
        else 
            valid2_memory[i] <= valid2_memory[i];
    end
end

always@(finished_phys_reg2)begin 
    for(i = 0; i <= station_amount; i = i + 1)begin
        if((address1_memory[i] == finished_phys_reg2) && valid1_memory[i] == 1'b0)
            valid1_memory[i] <= 1'b1;
        else 
            valid1_memory[i] <= valid1_memory[i];
    end
    for(i = 0; i <= station_amount; i = i + 1)begin
        if((address2_memory[i] == finished_phys_reg2) && valid2_memory[i] == 1'b0)
            valid2_memory[i] <= 1'b1;
        else 
            valid2_memory[i] <= valid2_memory[i];
    end
end

always@(finished_phys_reg3)begin 
    for(i = 0; i <= station_amount; i = i + 1)begin
        if((address1_memory[i] == finished_phys_reg3) && valid1_memory[i] == 1'b0)
            valid1_memory[i] <= 1'b1;
        else 
            valid1_memory[i] <= valid1_memory[i];
    end
    for(i = 0; i <= station_amount; i = i + 1)begin
        if((address2_memory[i] == finished_phys_reg3) && valid2_memory[i] == 1'b0)
            valid2_memory[i] <= 1'b1;
        else 
            valid2_memory[i] <= valid2_memory[i];
    end
end

always@(input_tag)begin 
    for(i = 0; i <= station_amount; i = i + 1)begin 
        if((valid1_memory[i] == 1'b1) && (valid2_memory[i] == 1'b1))begin
          reg_address1_out = address1_memory[i];
          reg_address2_out = address2_memory[i];
          output_tag = input_tag[i];
          operation_out = op_memory[i];
          station_index = station_index - 1;
          station_free[i] = 1'b1;
        end
        else
          station_free[i] = station_free[i];
        end
end
endmodule
