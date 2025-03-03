`timescale 1ns/1ps 

module registerAliasTable #(parameter reg_index = 4, phys_index = 5, tag_size = 5)(
    input [phys_index: 0] retired_phys_reg,
    input [phys_index: 0] reg_to_be_written1,
    input [phys_index: 0] reg_to_be_written2,
    input [phys_index: 0] read_reg1_one_in,
    input [phys_index: 0] read_reg2_one_in,
    input [phys_index: 0] read_reg1_two_in,
    input [phys_index: 0] read_reg2_two_in,
    input [tag_size: 0] instruction_tag1,
    input [tag_size: 0] instruction_tag2,
    output reg [phys_index: 0] read_reg1_one_out,
    output reg [phys_index: 0] read_reg2_one_out,
    output reg [phys_index: 0] read_reg1_two_out,
    output reg [phys_index: 0] read_reg2_two_out,
    output reg read_reg1_one_out_valid,
    output reg read_reg2_one_out_valid,
    output reg read_reg1_two_out_valid,
    output reg read_reg2_two_out_valid
);

localparam reg_amount = 32;
localparam phys_reg_amount = 64;
integer i;
reg [reg_amount - 1: 0] valid_reg;
reg [reg_amount - 1: 0] register;
reg [phys_index: 0] phys_to_arch_reg [reg_amount - 1: 0];
reg [phys_reg_amount - 1: 0] free_phys_reg;
//Initialize all valid bits to 1, physical to reg bits, free phys reg
initial begin
    for(i = 0; i < reg_amount; i = i + 1)begin
        valid_reg[i] = 1;
    end
    for(i = 0; i < reg_amount; i = i + 1)begin
        phys_to_arch_reg[i] = i;
        free_phys_reg[i] = 1;
    end
    for(i = 32; i < phys_reg_amount-1; i = i + 1)begin 
        free_phys_reg[i] = 0;
    end

end

always@(*)begin 
//Output the pointer to the physical register locations and its valid bit

    //Register one source 1
    if(valid_reg[read_reg1_one_in] == 1'b1)begin 
        read_reg1_one_out = phys_to_arch_reg[read_reg1_one_in];
        read_reg1_one_out_valid = 1'b1; 
    end
    else begin 
        read_reg1_one_out = phys_to_arch_reg[read_reg1_one_in];
        read_reg1_one_out_valid = 1'b0; 
    end
    //register two source 1
    if(valid_reg[read_reg2_one_in] == 1'b1)begin 
        read_reg2_one_out = phys_to_arch_reg[read_reg2_one_in];
        read_reg2_one_out_valid = 1'b1; 
    end
    else begin 
        read_reg2_one_out = phys_to_arch_reg[read_reg2_one_in];
        read_reg2_one_out_valid = 1'b0; 
    end

     //Register one source 2
    if(valid_reg[read_reg1_two_in] == 1'b1)begin 
        read_reg1_two_out = phys_to_arch_reg[read_reg1_two_in];
        read_reg1_two_out_valid = 1'b1; 
    end
    else begin 
        read_reg1_two_out = phys_to_arch_reg[read_reg1_two_in];
        read_reg1_two_out_valid = 1'b0; 
    end
    //register two source 2
    if(valid_reg[read_reg2_two_in] == 1'b1)begin 
        read_reg2_two_out = phys_to_arch_reg[read_reg2_two_in];
        read_reg2_two_out_valid = 1'b1; 
    end
    else begin 
        read_reg2_two_out = phys_to_arch_reg[read_reg2_two_in];
        read_reg2_two_out_valid = 1'b0; 
    end

    //Invalidate the registers to be written into
    //Rename the register to be written into a free physical reg location
    if(valid_reg[reg_to_be_written1] == 1'b1)begin
        valid_reg[reg_to_be_written1] = 1'b0;
    end
    else begin 
        for(i = 0; i < phys_reg_amount-1; i = i + 1)begin 
            if(free_phys_reg[i] == 1'b1)begin 
               phys_to_arch_reg[reg_to_be_written1] = i;
           end
           else begin 
               phys_to_arch_reg[i] = phys_to_arch_reg[i];
           end
        end
    end

    if(valid_reg[reg_to_be_written2] == 1'b1)begin
        valid_reg[reg_to_be_written2] = 1'b0;
    end
    else begin 
        for(i = 0; i < phys_reg_amount-1; i = i + 1)begin 
            if(free_phys_reg[i] == 1'b1)begin 
               phys_to_arch_reg[reg_to_be_written2] = i;
           end
           else begin 
               phys_to_arch_reg[i] = phys_to_arch_reg[i];
           end
        end
    end
end
//Retired physical reg valid for use again
always@(retired_phys_reg)begin 
    free_phys_reg[retired_phys_reg] = 1'b1;
end
    


endmodule



