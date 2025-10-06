<div align="center">
<h1>Oven Controller on CPLD</h1>
</div>

<!-- GitHub Badges Section -->
<p align="center">
  <img alt="Verilog" height="24.5px" style="padding-right:5px;" src="https://custom-icon-badges.demolab.com/badge/-Verilog-black?style=for-the-badge&logo=verilog&logoColor=white&logoSize=auto"/>
  <img alt="C++" height="24.5px" style="padding-right:5px;" src="https://custom-icon-badges.demolab.com/badge/-C++-005697?style=for-the-badge&logo=cpp&logoColor=white&logoSize=auto"/>
  <img alt="Quartus Prime" height="24.5px" style="padding-right:5px;" src="https://custom-icon-badges.demolab.com/badge/-Quartus Prime-024496?style=for-the-badge&logo=altera&logoColor=white&logoSize=auto"/>
  <img alt="Arduino" height="24.5px" style="padding-right:5px;" src="https://custom-icon-badges.demolab.com/badge/-Arduino-16969b?style=for-the-badge&logo=arduino&logoColor=white&logoSize=auto"/>
  <img alt="MIT" height="24.5px" style="padding-right:5px;" src="https://custom-icon-badges.demolab.com/badge/License-MIT-ad0808?style=for-the-badge"/>
    <br />
</p>

<!-- Description -->
<p align="center">
    <b>Oven Controller using MAX II CPLD and Quartus Prime</b><br>
    <i>with <code>Arduino</code> ADC Slave.</i>
</p>

## Overview

This project implements a **temperature-controlled oven system** using a **MAX II CPLD** that receives digital temperature data from an **Arduino Uno**.

The Arduino samples an **LM335 temperature sensor**, converts the analog signal into a digital temperature value, and transmits it bitwise to the CPLD through a simple **4-bit parallel ADC interface**.
Inside the CPLD, the `oven.v` top-level module processes this data, performs approximate voltage-to-temperature conversions using optimized **bit-shift operations** to fit into MAX II, and controls the oven’s heating element to maintain a **set temperature**.

## ⚙️ Functional Description

### 1. Arduino ADC Operation

The **Arduino** performs the following tasks:

* Samples the LM335 sensor using the built-in **10-bit ADC**.
* Averages **100 samples** to reduce noise.
* Converts the analog value to a **scaled temperature** (°C × 10 for precision).
* Sends the 8-bit integer temperature data to the CPLD using **4 parallel data lines (DATA_0–DATA_3)**.
* Signals data readiness using an **interrupt strobe (`ADC_INT`)**.
* Responds to CPLD’s **ADC Enable** signal to synchronize transmission.

Additional serial commands allow debugging and manual triggering:

```
S — Toggle STOP
P — Send START pulse
C=value — Update temperature value
```

---

### 2. CPLD Top-Level Design (`oven.v`)

The **CPLD RTL** acts as the **main oven controller**, containing the following subsystems:

#### ⏱️ Prescaler

Generates divided clock signals for timing control:

* `clk_250`, `clk_1`, and `clk_1000` (typical 250 Hz / 1 Hz / 1 kHz rates)
* Used by timer, blinking indicators, and display refresh.

#### 🔶 ADC Slave

Receives 4-bit parallel data and constructs 8-bit values representing:

* `digit_adc` — Raw ADC digits
* `current_temp` — Current temperature
* `set_temp` — Target temperature
* `set_time` — Heating duration

The CPLD synchronizes data transfers via the `adc_int` signal from Arduino and `adc_enable` output back to Arduino.

#### 🕒 Timer

Counts down from a configurable set time (`set_time`), triggered when heating begins.

#### 🔷 Segment Display Controller

Displays temperature and time on multiplexed **7-segment displays** (`D_out` and `D_enable`).

#### 🧠 Mealy FSM (Finite State Machine)

Implements the **oven control logic** with four states:

<div align="center">

| State  | Description                   | Condition                     | Action               |
| ------ | ----------------------------- | ----------------------------- | -------------------- |
| `idle` | System stopped or reset       | STOP pressed or timer expired | Heater off           |
| `low`  | Temperature below lower limit | `current_temp < lower_limit`  | Heater ON            |
| `set`  | Temperature within range      | Between limits                | Maintain temperature |
| `high` | Temperature above upper limit | `current_temp > upper_limit`  | Heater OFF           |

</div>

The FSM continuously adjusts the oven output (`oven` signal) to achieve the setpoint.

#### 💡 LED Indicators

<div align="center">

| LED        | Meaning                       |
| ---------- | ----------------------------- |
| `led_low`  | Heating (temperature too low) |
| `led_set`  | Temperature stable (in range) |
| `led_high` | Over-temperature (heater off) |
| `led_stop` | Blinks when STOP is active    |

</div>

## 🔧 Signal Summary

### CPLD I/O

<div align="center">

| Signal                        | Dir | Description                          |
| ----------------------------- | --- | ------------------------------------ |
| `clk`                         | In  | System clock                         |
| `start`, `stop`               | In  | Control inputs                       |
| `adc_data[3:0]`               | In  | 4-bit parallel ADC data from Arduino |
| `adc_int`                     | In  | Data strobe from Arduino             |
| `adc_enable`                  | Out | Enables Arduino ADC transmission     |
| `oven`                        | Out | Controls heater (active HIGH)        |
| `D_enable[7:0]`, `D_out[7:0]` | Out | 7-segment display control            |
| `led[3:0]`, `led_stop`        | Out | Status indicators                    |

</div>

## ⚡ Example Operation Sequence

1. **Arduino** samples LM335 → computes average temperature.
2. Sends 8-bit data to CPLD through `adc_data` and `adc_int`.
3. **CPLD** receives data and updates `current_temp`.
4. FSM compares `current_temp` with limits:

   * If below set temperature → `oven` signal ON.
   * If above → `oven` signal OFF.
5. **Timer** decrements until time expires, then system returns to `idle`.
6. LEDs and 7-segment displays update in real time.
