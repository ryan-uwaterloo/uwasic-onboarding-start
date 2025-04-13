<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This SPI-attached PWM peripheral registers in SPI inputs w/ a CDC chain then updates controller as per write requests, passing them on to the PWN driver.

## Register Map

| Addr | Register | Description | Reset Value |
|----|----|----|----|
| `0x00` | `en_reg_out_7_0` | Enable outputs on `uo_out[7:0]`   | `0x00`   |
| `0x01` | `en_reg_out_15_8` | Enable outputs on `uio_out[7:0]`   | `0x00`   |
| `0x02` | `en_reg_pwm_7_0` | Enable PWM for `uo_out[7:0]`   | `0x00`   |
| `0x03` | `en_reg_pwm_15_8` | Enable PWM for `uio_out[7:0]`   | `0x00`   |
| `0x04` | `pwm_duty_cycle` | PWM Duty Cycle ( `0x00`=0%, `0xFF`=100%) | `0x00`   |


## How to test

Push to github and pray :D

