# SPECTRA — Smart Pedestrian-Enabled Coordinated Traffic Regulation Architecture

SPECTRA is an FPGA-based traffic management system designed to coordinate four-way vehicle traffic while providing intelligent pedestrian crossing control. It uses a finite state machine (FSM) to manage traffic signal sequencing, process pedestrian requests, and maintain safe transitions between vehicle and pedestrian phases.

## Key Features

- **Four-Way Traffic Control:** Coordinates North, East, South, and West traffic signals using a predefined sequence.
- **Collision-Free Signal Sequencing:** Ensures that only one direction receives a green signal at a time, with yellow transitions and all-red clearance intervals.
- **Pedestrian Request Handling:** Accepts independent requests for all four crossings through push buttons.
- **Interrupt-Driven Pedestrian Service:** Temporarily suspends an eligible vehicle green phase to serve a pending pedestrian request.
- **Request Prioritization:** Uses a fixed priority order—North, East, South, then West—when multiple requests are pending.
- **Request Queuing:** Preserves unserved requests for subsequent eligible cycles.
- **Controlled Green-Time Extension:** Resumes the interrupted vehicle phase with its saved remaining time plus a configurable extension.
- **Digital Countdown Display:** Displays the remaining phase duration on seven-segment displays.
- **Configurable Timing:** Allows traffic and pedestrian timing parameters to be adjusted.

## Hardware Platform

| Component | Specification |
|---|---|
| FPGA Board | Terasic DE1 |
| FPGA Device | Intel/Altera Cyclone II EP2C20F484C7 |
| Description Language | Verilog HDL |
| Simulation | Vivado Simulator |
| Hardware Implementation | Intel Quartus II |
| Clock Source | 50 MHz onboard clock |
| User Inputs | Slide switches and push buttons |
| Outputs | Vehicle LEDs, pedestrian LEDs, and seven-segment displays |

External LEDs can be connected through the board's GPIO interface to represent the four vehicle signal assemblies and four pedestrian signals.

## System Architecture

The design is divided into reusable Verilog modules:

| Module | Function |
|---|---|
| `CLOCK_ENABLE_GEN` | Generates a one-second clock-enable pulse from the main FPGA clock. |
| `BUTTON_SYNC_DEBOUNCE` | Synchronizes push-button inputs, filters mechanical bounce, and generates request pulses. |
| `TRAFFIC_CONTROLLER_FSM` | Controls vehicle phases, pedestrian requests, timing, request prioritization, and phase resumption. |
| `TRAFFIC_LIGHT` | Decodes vehicle signal states into red, yellow, and green outputs. |
| `PEDESTRIAN_SIGNAL` | Generates WALK and DON'T WALK outputs. |
| `SEVEN_SEG_DECODER` | Converts the remaining phase time into seven-segment display patterns. |
| `TRAFFIC_LIGHT_TOP` | Integrates the modules into the complete FPGA design. |

## Traffic Control Operation

The vehicle signals follow a repeating sequence:

**North → East → South → West → North**

Each direction receives a green phase followed by yellow and an all-red clearance interval before traffic proceeds to the next direction.

When a pedestrian request is pending, the controller can interrupt an eligible green phase, save its remaining time, and temporarily place all vehicle signals at red. The selected pedestrian crossing receives a WALK signal, followed by a pedestrian clearance phase.

After pedestrian service, the interrupted vehicle phase resumes with its saved remaining time and a configurable green-time extension.

To regulate pedestrian interruptions, the controller permits one pedestrian service per complete four-direction traffic cycle. Additional requests remain pending until they can be served in a subsequent eligible cycle.

## Verification

The design is supported by Verilog/SystemVerilog testbenches for simulation-based waveform inspection.

Simulation can be used to observe:

- Vehicle signal sequencing and all-red clearance intervals.
- Push-button synchronization and debouncing.
- Pedestrian request capture and priority selection.
- Pedestrian service and vehicle phase resumption.
- Green-time extension and cycle-based service limits.
- Countdown timer behavior and seven-segment outputs.
