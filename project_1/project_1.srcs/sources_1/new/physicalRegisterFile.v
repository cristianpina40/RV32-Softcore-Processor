`timescale 1ns/1ps

module physicalRegisterFile
    #(parameter reg_index = 4, phys_index = 5, tag_size = 5, data_size = 31)(
    input [phys_index: 0] write_address1,
    input [phys_index: 0] write_address2,
    input [data_size: 0] physical_reg_write_data1,
    input [data_size: 0] physical_reg_write_data2,
    input [phys_index: 0] read_reg1_one_in,
    input [phys_index: 0] read_reg2_one_in,
    input [phys_index: 0] read_reg1_two_in,
    input [phys_index: 0] read_reg2_two_in,
    output reg [data_size: 0] read_reg1_one_out,
    output reg [data_size: 0] read_reg2_one_out,
    output reg [data_size: 0] read_reg1_two_out,
    output reg [data_size: 0] read_reg2_two_out
    );

    localparam phys_reg_amount = 63;
    integer i;
    reg [data_size: 0] physical_registers [phys_reg_amount: 0];

    initial begin 
        for(i = 0; i < phys_reg_amount + 1; i = i + 1)
            physical_registers[i] = i;
    end

    always@(read_reg1_one_in)begin 
        read_reg1_one_out <= physical_registers[read_reg1_one_in];
    end

    always@(read_reg2_one_in)begin 
        read_reg2_one_out <= physical_registers[read_reg2_one_in];
    end

    always@(read_reg1_two_in)begin 
        read_reg1_two_out <= physical_registers[read_reg1_two_in];
    end

    always@(read_reg2_two_in)begin 
        read_reg2_two_out <= physical_registers[read_reg2_two_in];
    end

    always@(*)begin 
        physical_registers[write_address1] <= physical_reg_write_data1;
        physical_registers[write_address2] <= physical_reg_write_data2;
    end
endmodule