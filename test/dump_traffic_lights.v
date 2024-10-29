module dump();
    initial begin
        $dumpfile ("traffic_lights.vcd");
        $dumpvars (0, traffic_lights);
        #1;
    end
endmodule