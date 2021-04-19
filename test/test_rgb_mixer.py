import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
import random
from test.test_encoder import Encoder

clocks_per_phase = 10

#General Purpose helper func
#seems that cocotb don't deal with 
#RisingEdge(example_bus[0]
#calling await until_posedge_signal(clk,example[0]) 
#fix this issue
async def until_posedge_signal(clk, sig):
    while True:
        await RisingEdge(clk)
        if (sig.value == 0):
            break
    while True:
        await RisingEdge(clk)
        if (sig.value == 1):
            return

async def reset(dut):
    dut.enca[0] <= 0
    dut.encb[0] <= 0
    dut.enca[1] <= 0
    dut.encb[1] <= 0
    dut.enca[2] <= 0
    dut.encb[2] <= 0
    dut.reset  <= 1

    await ClockCycles(dut.clk, 5)
    dut.reset <= 0;
    await ClockCycles(dut.clk, 5) # how long to wait for the debouncers to clear

async def run_encoder_test(encoder, dut_enc, max_count):
    for i in range(clocks_per_phase * 2 * max_count):
        await encoder.update(1)

    # let noisy transition finish, otherwise can get an extra count
    for i in range(10):
        await encoder.update(0)
    
    assert(dut_enc == max_count)

@cocotb.test()
async def test_all(dut):
    clock = Clock(dut.clk, 10, units="us")
    encoder0 = Encoder(dut.clk, dut.enca[0], dut.encb[0], clocks_per_phase = clocks_per_phase, noise_cycles = clocks_per_phase / 4)
    encoder1 = Encoder(dut.clk, dut.enca[1], dut.encb[1], clocks_per_phase = clocks_per_phase, noise_cycles = clocks_per_phase / 4)
    encoder2 = Encoder(dut.clk, dut.enca[2], dut.encb[2], clocks_per_phase = clocks_per_phase, noise_cycles = clocks_per_phase / 4)

    cocotb.fork(clock.start())

    await reset(dut)
    assert dut.enc2 == 0
    assert dut.enc1 == 0
    assert dut.enc0 == 0

    # pwm should all be low at start
    assert dut.pwm_out[0] == 0
    assert dut.pwm_out[1] == 0
    assert dut.pwm_out[2] == 0

    # do 3 ramps for each encoder 
    max_count = 255
    await run_encoder_test(encoder0, dut.enc0, max_count)
    await run_encoder_test(encoder1, dut.enc1, max_count)
    await run_encoder_test(encoder2, dut.enc2, max_count)

    # sync to pwm
    #await RisingEdge(dut.pwm_out[0]) #not actually supported in cocotb
    await until_posedge_signal(dut.clk, dut.pwm_out[0])
    #await RisingEdge(dut.pwm_out0) #use the helper wire defined in the verilog module
    # pwm should all be on for max_count 
    for i in range(max_count): 
        assert dut.pwm_out[0] == 1
        assert dut.pwm_out[1] == 1
        assert dut.pwm_out[2] == 1
        await ClockCycles(dut.clk, 1)
