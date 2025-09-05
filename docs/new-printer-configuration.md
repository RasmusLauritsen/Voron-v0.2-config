# Configuring a new printer running Klipper

Inspired by this video: [Canuck Creator - Klipper initial setup](https://www.youtube.com/watch?v=T-knWbh1Gg8):
### 1. Ensure everything registered and showing up as expected.
    1. Check temperatures - should messure room teperatures on all sensors.
    2. Check fans. Can they spin? Test using Mainsail.
    3. Check endstops. Trigger them and verify in Mainsail.


### 2. Stepper buzz (Checking the motors are moving in the right direction)
See video above for details.


### 3. Z height / offset calibration
1. Verify corrrect settings for `microsteps` in `[stepper_z]`.
2. Clean the nozzle!
3. `Z_ENDSTOP_CALIBRATE`followed by `SAVE_CONFIG`.
4. `BED_SCREWS_ADJUST`
5. `Z_ENDSTOP_CALIBRATE`followed by `SAVE_CONFIG`.
6. `BED_MESH_CLEAR` followed by `BED_MESH_CALIBRATE`.


### 4. Extruding - calibration
Temporarely allow cold extrusion in printer config, and then restart klipper.
Ensure that the filament isn't going into the hotend at this point - we want to messure e-steps on the extruder motor.
```klipper
[extruder]
 ..
min_extrude_temp: 0
 ..
```

1. Extrude 100mm of filament, and messure extruded filament.
2. If messured value isn't 100mm, then:
    1. Ensure the values for `full_steps_per_rotation`, `gear_ratio`, `microsteps` is correct.
    2. Calculate: <Measured value>/100*<current rotation_distance value> = new rotation_distance value
    3. Replace rotation_distance and restart. Repeat until perfect.
3. Remove `min_extrude_temp: 0` from config.


### 5. PID calibration (Mainsail console)
Run the following commands in mainsail console.
```klipper
PID_CALIBRATE HEATER=extruder TARGET=230    ; Use temperature for your most used filament
PID_CALIBRATE HEATER=heater_bed TARGET=80   ; Use temperature for your most used filament
SAVE_CONFIG                                 ; Restart printer
```

### 6. Input shaper: [Canuck Creator - Input shaping](https://www.youtube.com/watch?v=OoWQUcFimX8)
Documentation:
- https://www.klipper3d.org/Resonance_Compensation.html
- https://www.klipper3d.org/Measuring_Resonances.html#input-shaper-auto-calibration

Test if acelerometer is found: `ACCELEROMETER_QUERY`  
If yes, then calibrate with:
```klipper
SHAPER_CALIBRATE
SAVE_CONFIG
```


### 7. Pressure advance: [Canuck Creator - Pessure Advance](https://www.youtube.com/watch?v=LtG--ev3-4s)
Pressure advance will change with different filaments, brands, nozzle sizzes, when en/dis-abling inputshaping. Should be done AFTER input-shapring configuration.

Good documentation on PA:
- [Ellis' Print Tuning Guide - Pressure Advance](https://ellis3dp.com/Print-Tuning-Guide/articles/pressure_linear_advance/introduction.html)
- https://github.com/Klipper3d/klipper/blob/master/docs/Pressure_Advance.md

**Download** [square_tower.stl](https://github.com/Klipper3d/klipper/blob/master/docs/prints/square_tower.stl), and **slice** with these settings:

    - Use a high speed (eg, 100mm/s)
    - Zero infill
    - Coarse layer height (the layer height should be around 75% of the nozzle diameter).
        - 0.4mm nozzle = 0.3mm layer height
        - 0.6mm nozzle = ~0.45mm layer height
    - Make sure any "dynamic acceleration control" and "scarf joint" seams are disabled in the slicer.*


Prepare for the test by issuing the following **G-Code** commands in **Mainsail console**:
```klipper
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005  ; Direct drive
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.020  ; Bowden
```

**Messure** with a ruler, where the **best corners** are and use that value:  
`<start> + <best height> * FACTOR = New pressure_advance value`  
Ex: `0 + 19mm * 0.005 = 0,095`

Update printer config - under the **[extruder]**
```klipper
[extruder]
pressure_advance = <calculated_value>
```

## Configure filament
[Fine tune filament](new-filament.md)

