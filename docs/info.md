
Cada bit debe enviarse sincronizado con el reloj (`clk`).

---

### 3. Selección de operación
Antes o durante la carga se define:

- `000` → Suma
- `001` → AND
- `010` → OR
- `011` → XOR
- `100` → Resta

---

### 4. Ejecución automática
Cuando el contador llega a 14:

- `flag_14 = 1`
- Se ejecuta la operación seleccionada
- `done = 1`
- El resultado aparece en `r0–r6`

---

### 5. Resultados esperados

Con A = 1111111, B = 1111111


Resultados:

- Suma → 1111110 (overflow en 7 bits)
- AND → 1111111
- OR → 1111111
- XOR → 0000000
- Resta → 0000000

---

## External hardware

Este proyecto puede implementarse en simulación o hardware FPGA.

### Simulación recomendada:
- Digital (Java tool)
- Vivado
- Quartus
- ModelSim / GTKWave

---

### Hardware opcional (FPGA):

Entradas:
- `bit_in` → switch o botón
- `op_select` → 3 switches
- `reset` → botón

Salidas:
- `r0–r6` → 7 LEDs
- `done` → LED indicador

---

### Visualización sugerida:
- LEDs para cada bit del resultado
- LED adicional para señal `done`

