# Klipper config for Fysetc Voron 0.2 R1 V1.1 Pro
My Klipper config as well as a few notes on how to configure the slicer.  
The printer is built from [this kit](https://www.aliexpress.com/item/1005008626712100.html).

#### Hardware Components
* Mainboard: **Fysetc Catalyst v2.1**
* * MCU (Main Control Board): **STM32F446**
* * Steppers: **TMC2209**
* Host computer: **CM68** (Rockchip RK3568 2GB+32GB) (RPi compute module formfactor) mounted on the Catalyst board
* Tool head board: **M36**
* * MCU: **STM32F072**
* * Accelerometer: **ADXL345**
* Hotend: [**Sailfish High Flow**](https://www.fysetc.com/products/fysetc-v6-hotend-sailfish-high-flow-speed-v6-j-head-kit-extrude-head-for-cr-10-cr10s-ender-3-ender3-pro-voron-2-4-3d-printer-hotend) (Same mount as Dragon)
* Display:[**Fysetc Voron V0 1.3" OLED**](https://www.fysetc.com/products/fysetc-voron-v0-1-3-inch-oled-display-screen-smart-display-for-raspberry-pi-3-b-voron-v0-3d-printer-accessories)

## Update Klipper  
See [this guide](docs/update-klipper.md)


## Built a new Printer? 
See [configuring klipper for a new printer](/docs/new-printer-configuration.md)


## Slicer / PrusaSlicer / OrcaSlicer / SuperSlicer
Add a Voron v0 using the setup wizard

### Change the following:
1. Add V0 from Configuration Wizard.
2. Add [A better print_start macro](https://github.com/jontek2/A-better-print_start-macro) gcode to `Start g-code`.  
`Printer settings` --> `Custom g-code` -> `Start g-code`
```
M104 S0 ; Stops PrusaSlicer from sending temp waits separately
M140 S0
print_start EXTRUDER=[first_layer_temperature[initial_extruder]] BED=[first_layer_bed_temperature] CHAMBER=[chamber_temperature] CHAMBER_MIN=[chamber_minimal_temperature]
```

3. Add [A better print_start macro](https://github.com/jontek2/A-better-print_start-macro) to macros.cfg (already added in this repo).  
I modified it slightly to use PrusaSlicers chamber_minimal_temperature instead of chamber_temperature. If bed temp is 90+, then wait until chamber_minimal_temperature is reached before starting the print.

4. Change all `Print settings` with a custom output name, and `Label objects` to `Firmware-specific`.  
`Print settings` --> `Output options` --> `Output filename format`:
```
{input_filename_base}_{print_time}_{nozzle_diameter[0]}n_{layer_height}mm_{filament_type[0]}_{printer_model}.gcode
```

## New filament
[Finetune filament](docs/new-filament.md) (pressure advance, flow calibration etc.)

## Mobileraker - control Klipper from your phone
<img src="https://mobileraker.com/img/mr_logo.png" width="100">

Mobileraker works as a simple UI for Klipper on your phone. Connect it to an existing moonraker installation and start controlling your printer.

[!["AppStore"](https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/us/app/mobileraker/id1581451248)
[!["PlayStore"](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=com.mobileraker.android)

