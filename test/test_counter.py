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
    
    await reset(dut)
    # test a range of values
    for i in range(1, 300, 1):
        await RisingEdge(dut.clk)
        # # set pwm to this level
        # dut.level.value = i

        if dut.processQ.value == 127:
            assert(dut.roll)
