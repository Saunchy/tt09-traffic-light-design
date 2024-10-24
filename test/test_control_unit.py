import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
import random

async def reset(dut):
    dut.reset_n.value = 0

    await ClockCycles(dut.clk, 5)
    dut.reset_n.value = 1;

@cocotb.test()
async def test_counter(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    
    dut.sw_traffic_lights.value = 0
    await reset(dut)
    # test a range of values
    for i in range(1, 50, 1):
        await RisingEdge(dut.clk)

        if i == 10:
            dut.sw_traffic_lights.value = 2 #go green

        if i == 20:
            dut.sw_traffic_lights.value = 3 #go yellow

        if i == 30: 
            dut.sw_traffic_lights.value = 1 #go red

