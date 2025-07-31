# VGA Project with Pmod PIR Sensor (Basys3, Verilog)

This Verilog project runs on the Basys3 FPGA development board and displays a graphical output via VGA with Full HD resolution (1920x1080). A motion sensor (Pmod PIR) is connected to the board and its output is used to trigger a visual effect on screen.

The screen normally shows a black background. When the PIR sensor detects motion (i.e., its `pir_out` signal becomes high), a red square is displayed in the center of the screen. The purpose is to visualize motion detection in real-time.

The project uses a 148.5 MHz pixel clock to match Full HD VGA timing. VGA synchronization signals are generated using a `vga_sync` module, and drawing is done based on current pixel coordinates (`h_cnt`, `v_cnt`). The logic checks whether the current pixel is inside the red square area, and colors it accordingly only when the PIR signal is active.

All Verilog modules are connected inside the `topp.v` top-level module. The PIR signal is declared as an input and directly used in the color logic. There is no need for complex filtering, as the Pmod PIR already outputs a stable digital signal.

To use the design, program the Basys3 board with the generated bitstream and connect a Pmod PIR sensor to one of the available PMOD ports. Then, connect a VGA cable to a monitor and observe the red square appearing when movement is detected in front of the sensor.

This project demonstrates how to interface a digital sensor and create a visual reaction in hardware using Verilog and VGA output.
