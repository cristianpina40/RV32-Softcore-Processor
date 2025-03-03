`timescale 1ns/1ps 

module reorderBuffer #(parameter reg_index = 4, phys_index = 5, tag_size = 5)(
    input [tag_size: 0] tag_data_in,
    input [reg_index: 0] reg_index_in,
    input [tag_size: 0] tag_complete1,
    input [tag_size: 0] tag_complete2,
    input [tag_size: 0] tag_complete3,
    input [phys_index: 0] physical_reg_in,
    output reg [tag_size: 0] retired_tag,
    output reg [tag_size: 0] dispatch_tag,
    output reg [reg_index: 0] reg_index_out,
    output reg [phys_index: 0] physical_reg_out,
    output reg rob_full
); 

integer i;
parameter rob_size = 31;
parameter rob_index = 4;
//Values to be held inside the ROB entries
reg [rob_size: 0] clear_bit;
reg [rob_size: 0] valid_entry_bit; 
reg [tag_size: 0] tagInputs [rob_size: 0];
reg [rob_size: 0] valid_bit;
reg [phys_index: 0] physical_reg_saved [rob_size: 0];
reg [reg_index: 0] reg_index_saved [rob_size: 0];
//Indexing inside of the 32 entry ROB
reg [rob_index: 0] pointer_top_data;
reg [rob_index: 0] rob_counter;

//Input entry save logic
always@(tag_data_in)begin 
    if(rob_counter == 0)begin 
        tagInputs[rob_counter] = tag_data_in; 
        physical_reg_saved[rob_counter] = physical_reg_in; 
        reg_index_saved[rob_counter] = reg_index_in;
        valid_bit[rob_counter] = 0;
        valid_entry_bit[rob_counter] = 1;
        clear_bit[rob_counter] = 0;
        rob_full = 0;
        rob_counter = rob_counter + 1;
    end 
    else if((rob_counter > 0) && (rob_counter < 31))begin 
        tagInputs[rob_counter] = tag_data_in; 
        physical_reg_saved[rob_counter] = physical_reg_in; 
        reg_index_saved[rob_counter] = reg_index_in;
        valid_bit[rob_counter] = 0;
        valid_entry_bit[rob_counter] = 1;
        clear_bit[rob_counter] = 0;
        rob_full = 0;
        rob_counter = rob_counter + 1;
    end
    else if (rob_counter >= 31)begin 
        rob_full = 1;
    end 
    else begin 
        rob_full = 1;
    end 

end 
//tag_complete logic check if the
always@(tag_complete1)begin 
    for(i = 0; i < rob_size + 1; i = i + 1)begin 
        if(tagInputs[i] == tag_complete1 && valid_entry_bit[i] == 1)begin 
            valid_bit[i] = 1;
        end 
        else 
            valid_bit[i] = valid_bit[i];
    end
end 

always@(tag_complete2)begin 
    for(i = 0; i < rob_size + 1; i = i + 1)begin 
        if(tagInputs[i] == tag_complete2 && valid_entry_bit[i] == 1)begin 
            valid_bit[i] = 1;
        end 
        else 
            valid_bit[i] = valid_bit[i];
    end
end 

always@(tag_complete3)begin 
    for(i = 0; i < rob_size + 1; i = i + 1)begin 
        if(tagInputs[i] == tag_complete3 && valid_entry_bit[i] == 1)begin 
            valid_bit[i] = 1;
        end 
        else 
            valid_bit[i] = valid_bit[i];
    end
end 

//dispatch the completed top instruction tag and set clear bit high
always@(*)begin
        if(valid_bit[0] == 1)begin 
            retired_tag = tagInputs[0];
            dispatch_tag = tagInputs[0]; 
            physical_reg_out = physical_reg_saved[0];
            reg_index_out = reg_index_saved[0];
            tagInputs[0] = 0; 
            physical_reg_saved[0] = 0; 
            reg_index_saved[0] = 0;
            clear_bit[0] = 1; 
            rob_counter = rob_counter - 1;
            valid_bit[0] = 0;
        end 
        else 
            valid_bit[0] = valid_bit[0];
    end 
//Check for clear bit high, if clear bit high pull up rob entry index
always@(*)begin 
    for(i = 0; i < rob_size + 1; i = i + 1)begin 
        if((clear_bit[i] == 1) && (valid_entry_bit[i + 1] == 1) && i < 30)begin 
            tagInputs[i] = tagInputs[i + 1]; 
            physical_reg_saved[i] = physical_reg_saved[i + 1]; 
            reg_index_saved[i] = reg_index_saved[i + 1];
            valid_bit[i] = valid_bit[i + 1];
            valid_entry_bit[i] = valid_entry_bit[i + 1];
            clear_bit[i + 1] = 1;
            clear_bit[i] = 0;
        end
        else if((clear_bit[i] == 1) && (valid_entry_bit[i + 1] == 0))begin 
            tagInputs[i] = 0; 
            physical_reg_saved[i] = 0; 
            reg_index_saved[i] = 0;
            valid_bit[i] = 0;
            valid_entry_bit[i] = 0;
            clear_bit[i] = 0;
        end
        else if((clear_bit[i] == 1) && i == 31)begin 
            tagInputs[i] = 0; 
            physical_reg_saved[i] = 0; 
            reg_index_saved[i] = 0;
            valid_bit[i] = 0;
            valid_entry_bit[i] = 0;
            clear_bit[i] = 0;
        end
        else 
            clear_bit[0] = 0;
        end
end

endmodule
