module dump();
    initial begin
        $dumpfile ("control_unit.vcd");
        $dumpvars (0, control_unit);
        #1;
    end
endmodule