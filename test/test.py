# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_alu(dut):
    dut._log.info("Start ALU test")

    # Clock 100 KHz
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # =========================
    # RESET
    # =========================
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Sending serial data")

    # =========================
    # CONFIGURAR OPERACIÓN
    # =========================
    # op_select = 000 (SUMA)
    op = 0b000

    # regA = 7 bits (ej: 5 = 0000101)
    A = 0b0000101

    # regB = 7 bits (ej: 3 = 0000011)
    B = 0b0000011

    # meter op_select en ui_in[3:1]
    dut.ui_in.value = (op << 1)

    # =========================
    # ENVIAR 14 BITS SERIALMENTE
    # =========================
    data = (A << 7) | B   # 14 bits

    for i in range(14):
        bit = (data >> (13 - i)) & 1
        dut.ui_in.value = (int(dut.ui_in.value) & 0b11110000) | bit
        await ClockCycles(dut.clk, 1)

    # =========================
    # ESPERAR RESULTADO
    # =========================
    await ClockCycles(dut.clk, 5)

    dut._log.info("Checking result")

    # =========================
    # RESULTADO ESPERADO
    # =========================
    # 5 + 3 = 8 → 0001000
    expected = 0b0001000

    actual = (
        (dut.uo_out.value.integer & 0b01111111)
    )

    assert actual == expected, f"Expected {expected}, got {actual}"
