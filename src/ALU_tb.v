`timescale 1ns/1ps

module tb_ALU;

  reg clk;
  reg reset;
  reg bit_in;
  reg [2:0] op_select;

  wire r0, r1, r2, r3, r4, r5, r6;
  wire done;

  // DUT
  ALU uut (
    .clk(clk),
    .reset(reset),
    .bit_in(bit_in),
    .op_select(op_select),
    .r0(r0), .r1(r1), .r2(r2),
    .r3(r3), .r4(r4), .r5(r5), .r6(r6),
    .done(done)
  );

  // reloj
  always #5 clk = ~clk;

  // =========================
  // TAREA: RESET LIMPIO
  // =========================
  task do_reset;
  begin
    reset = 1;
    bit_in = 0;
    repeat(2) @(posedge clk); // asegurar limpieza
    reset = 0;
  end
  endtask

  // =========================
  // TAREA: ENVIAR DATOS
  // =========================
  task send_data;
    input [6:0] A;
    input [6:0] B;
    integer i;
    begin
      // A
      for (i = 6; i >= 0; i = i - 1) begin
        bit_in = A[i];
        @(posedge clk);
      end

      // B
      for (i = 6; i >= 0; i = i - 1) begin
        bit_in = B[i];
        @(posedge clk);
      end

      bit_in = 0; // importante después
    end
  endtask

  // =========================
  // MONITOR
  // =========================
  initial begin
    $monitor("t=%0t | done=%b | result=%b%b%b%b%b%b%b",
      $time, done, r6,r5,r4,r3,r2,r1,r0);

    $dumpfile("alu.vcd");
    $dumpvars;
  end

  // =========================
  // PRUEBAS
  // =========================
  initial begin
    clk = 0;
    reset = 0;
    bit_in = 0;
    op_select = 0;

    // -------- SUMA --------
    do_reset();
    op_select = 3'b000;
    send_data(7'b0000011, 7'b0000001); // 3 + 1
    wait(done);
    @(posedge clk);

    // -------- AND --------
    do_reset();
    op_select = 3'b001;
    send_data(7'b1010101, 7'b1110000);
    wait(done);
    @(posedge clk);

    // -------- OR --------
    do_reset();
    op_select = 3'b010;
    send_data(7'b1010101, 7'b0101010);
    wait(done);
    @(posedge clk);

    // -------- XOR --------
    do_reset();
    op_select = 3'b011;
    send_data(7'b1111111, 7'b0000000);
    wait(done);
    @(posedge clk);

    // -------- RESTA --------
    do_reset();
    op_select = 3'b100;
    send_data(7'b0000111, 7'b0000010); // 7 - 2
    wait(done);
    @(posedge clk);

    $finish;
  end

endmodule