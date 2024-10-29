module dump();
    initial begin
        $dumpfile ("glue_logic.vcd");
        $dumpvars (0, glue_logic);
        #1;
    end
endmodule