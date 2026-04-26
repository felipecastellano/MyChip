module ALU (
    input wire clk,
    input wire reset,
    input wire bit_in,
    input wire [2:0] op_select,

    output reg r0,
    output reg r1,
    output reg r2,
    output reg r3,
    output reg r4,
    output reg r5,
    output reg r6,

    output wire done
);

    // =========================
    // CONTADOR
    // =========================
    reg [3:0] count = 0;
    reg flag_14 = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            flag_14 <= 0;
        end else begin
            if (count < 13) begin
                count <= count + 1;
                flag_14 <= 0;
            end else begin
                count <= 13;
                flag_14 <= 1;
            end
        end
    end

    assign done = flag_14;

    // =========================
    // REGISTROS
    // =========================
    reg [6:0] regA = 0;
    reg [6:0] regB = 0;
    reg [3:0] bit_count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            regA <= 0;
            regB <= 0;
            bit_count <= 0;
        end else begin
            if (!flag_14) begin
                if (bit_count < 7)
                    regA <= {regA[5:0], bit_in};
                else if (bit_count < 14)
                    regB <= {regB[5:0], bit_in};

                bit_count <= bit_count + 1;
            end
        end
    end

    // =========================
    // ALU (UNA SOLA VEZ)
    // =========================
    reg [6:0] result;
    reg executed = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 0;
            executed <= 0;
        end else begin
            if (flag_14 && !executed) begin
                case (op_select)  // 🔥 USO DIRECTO
                    3'b000: result <= regA + regB;
                    3'b001: result <= regA & regB;
                    3'b010: result <= regA | regB;
                    3'b011: result <= regA ^ regB;
                    3'b100: result <= regA - regB;
                    default: result <= 0;
                endcase
                executed <= 1;
            end
        end
    end

    // =========================
    // SALIDAS
    // =========================
    always @(*) begin
        r0 = result[0];
        r1 = result[1];
        r2 = result[2];
        r3 = result[3];
        r4 = result[4];
        r5 = result[5];
        r6 = result[6];
    end

endmodule