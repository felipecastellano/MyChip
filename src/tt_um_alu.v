`default_nettype none

module tt_um_alu (
    input  wire [7:0] ui_in,    // entradas dedicadas
    output wire [7:0] uo_out,   // salidas dedicadas
    input  wire [7:0] uio_in,   // IOs entrada
    output wire [7:0] uio_out,  // IOs salida
    output wire [7:0] uio_oe,   // enable IOs
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // =========================
    // INSTANCIA DE LA ALU
    // =========================
    ALU alu_inst (
        .clk(clk),
        .reset(!rst_n),

        .bit_in(ui_in[0]),        // entrada serial
        .op_select(ui_in[3:1]),   // selección de operación

        .r0(uo_out[0]),
        .r1(uo_out[1]),
        .r2(uo_out[2]),
        .r3(uo_out[3]),
        .r4(uo_out[4]),
        .r5(uo_out[5]),
        .r6(uo_out[6]),

        .done(uo_out[7])          // bandera de terminado
    );

    // =========================
    // SALIDAS NO USADAS
    // =========================
    assign uio_out = 8'bz;
    assign uio_oe  = 8'b0;

    // =========================
    // MANEJO DE SEÑALES NO USADAS
    // =========================
    wire _unused = &{ena, uio_in, ui_in[7:4], 1'b0};

endmodule