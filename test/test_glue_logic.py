import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
import random

async def reset(dut):
    dut.reset_n.value = 0

    await ClockCycles(dut.roll, 5)
    dut.reset_n.value = 1;

@cocotb.test()
async def test_glue_logic(dut):
    roll = Clock(dut.roll, 1, units="us")
    cocotb.start_soon(roll.start())
    
    await reset(dut)
    # test a range of values
    for i in range(1, 100, 1):
        await RisingEdge(dut.roll)
        # # set pwm to this level
        # dut.level.value = i
        if i == 35:
            dut.btn.value = 1
        else:
            dut.btn.value = 0

        # if dut.processQ.value == 127:
        #     assert(dut.roll)
