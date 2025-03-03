`timescale 1ns/1ps 

module architecturalRegisterFile
#(parameter reg_index = 4, phys_index = 5, tag_size = 5, data_size = 31)(
    input [reg_index: 0] write_address1,
    input [reg_index: 0] write_address2,
    input [data_size: 0] write_data1,
    input [data_size: 0] write_data2
);

reg [reg_index: 0] registers [data_size: 0];

always@(write_address1)begin 
    registers[write_address1] <= write_data1;
end

always@(write_address2)begin 
    registers[write_address2] <= write_data2;
end
endmodule
