# Configuring a new Voron V0 with Klipper and Klicky

This checklist is for a printer configured like this repository: Voron V0 size, sensorless X/Y homing, a detachable Klicky-style probe, and `probe:z_virtual_endstop` for Z.

Do not rush the order. Each step depends on the previous one being trustworthy.

## 1. Basic safety checks

Before moving anything:

1. Verify every configured MCU is online in Mainsail.
2. Confirm all temperature sensors report realistic room temperature.
3. Confirm heaters are assigned correctly. Heat bed and hotend briefly at low power and watch the correct temperature rise.
4. Verify fans can spin from Mainsail.
5. Verify emergency stop and power-off behavior.

Do not continue if any thermistor, heater, or fan is mapped incorrectly.

## 2. Endstop and probe input checks

Run:

```klipper
QUERY_ENDSTOPS
QUERY_PROBE
```

For sensorless X/Y, `stepper_x` and `stepper_y` should normally show `open` when the toolhead is away from the physical limits.

For Klicky:

1. Run `QUERY_PROBE` with the probe docked.
2. Attach or manually trigger the probe.
3. Run `QUERY_PROBE` again.

The probe state must change. If it does not, fix the probe pin, pull-up, or inversion before trying to home Z.

## 3. Stepper buzz and motor direction

Use Klipper's stepper buzz checks before homing:

```klipper
STEPPER_BUZZ STEPPER=stepper_x
STEPPER_BUZZ STEPPER=stepper_y
STEPPER_BUZZ STEPPER=stepper_z
STEPPER_BUZZ STEPPER=extruder
```

Fix motor direction, stepper assignment, and CoreXY movement before any homing tests.

For a V0 with sensorless homing:

1. X and Y must move in the correct CoreXY directions.
2. X and Y DIAG pins must report correctly.
3. `homing_positive_dir` must match the endstop side.
4. Sensorless sensitivity should be conservative at first.

## 4. Sensorless X/Y homing

Test one axis at a time:

```klipper
G28 X
G28 Y
```

Expected behavior:

1. The axis moves toward its homing side.
2. It stalls cleanly.
3. It backs off.
4. `QUERY_ENDSTOPS` does not show the axis permanently triggered afterward.

Only after X and Y work independently, run:

```klipper
G28 X Y
```

## 5. Configure Klicky docking movement

Set the Klicky variables before relying on automatic attach/dock:

```klipper
variable_docklocation_x
variable_docklocation_y
variable_dockmove_x
variable_dockmove_y
Variable_attachmove_x
Variable_attachmove_y
Variable_attachmove2_x
Variable_attachmove2_y
```

For a probe used as the Z endstop, set:

```klipper
variable_z_endstop_x: 0
variable_z_endstop_y: 0
```

That tells Klicky to calculate a bed-center Z probing position from the bed size and probe offsets.

Then test:

```klipper
G28 X
G28 Y
Attach_Probe
Dock_Probe
```

The probe must attach and dock repeatedly without trying to move outside the bed.

## 6. Full homing with probe as Z endstop

Once X/Y homing and Klicky attach/dock are reliable, test full homing:

```klipper
G28
```

Expected order:

1. Home X/Y.
2. Attach the probe.
3. Move so the probe is over the bed-center Z probing point.
4. Home Z using `probe:z_virtual_endstop`.
5. Dock the probe.

If Klipper reports `Move out of range`, fix the Klicky coordinates before continuing.

## 7. Heater PID tuning

PID tune after basic motion is safe, but before doing temperature-sensitive calibration like bed mesh and first layer tuning.

Use common print temperatures:

```klipper
PID_CALIBRATE HEATER=heater_bed TARGET=80
SAVE_CONFIG
```

After Klipper restarts:

```klipper
PID_CALIBRATE HEATER=extruder TARGET=230
SAVE_CONFIG
```

Use different targets if your normal materials need different temperatures.

## 8. Extruder rotation distance

Calibrate extruder rotation distance before pressure advance.

Temporarily allow cold extrusion if measuring without feeding into the hotend:

```klipper
[extruder]
min_extrude_temp: 0
```

Restart Klipper, mark filament, extrude 100 mm, then calculate:

```text
new_rotation_distance = measured_length / 100 * current_rotation_distance
```

Update `rotation_distance`, restart, and repeat until the extruder moves the requested length. Remove `min_extrude_temp: 0` afterward.

## 9. Probe Z offset calibration

Do this after full `G28` works.

Clean the nozzle and bed first. Any plastic on the nozzle will corrupt the offset.

Run:

```klipper
G28
PROBE_CALIBRATE
```

Use `TESTZ` until the nozzle just grips paper:

```klipper
TESTZ Z=-1
TESTZ Z=-0.1
TESTZ Z=0.05
```

Finish with:

```klipper
ACCEPT
SAVE_CONFIG
```

If Klipper blocks negative Z moves during calibration, loosen `[stepper_z] position_min` temporarily, for example:

```klipper
position_min: -5
```

## 10. Mechanical bed adjustment

After the probe offset is saved, adjust the bed mechanically.

For a V0 bed with screws:

```klipper
G28
BED_SCREWS_ADJUST
```

Repeat until the bed is mechanically close. If using screws tilt macros instead, run the equivalent `SCREWS_TILT_CALCULATE` workflow.

If the mechanical adjustment changed the bed height significantly, rerun:

```klipper
G28
PROBE_CALIBRATE
ACCEPT
SAVE_CONFIG
```

## 11. Bed mesh

Bed mesh depends on:

1. Correct probe offset.
2. Mechanical bed adjustment.
3. Bed at print temperature.

Heat the bed first:

```klipper
G28
M190 S80
BED_MESH_CLEAR
BED_MESH_CALIBRATE
SAVE_CONFIG
```

For this style of config, it is also fine for `PRINT_START` to run a fresh mesh after the bed reaches print temperature.

## 12. Input shaper

Input shaper should be calibrated after:

1. Motion directions are correct.
2. Belts are tensioned.
3. The toolhead is fully assembled.
4. The accelerometer is mounted in its final orientation.
5. Probe and bed setup are stable enough that the printer can home safely.

Check the accelerometer:

```klipper
ACCELEROMETER_QUERY
```

Then run:

```klipper
SHAPER_CALIBRATE
SAVE_CONFIG
```

Input shaper changes the useful acceleration range, so do this before pressure advance and speed tuning.

## 13. Pressure advance

Tune pressure advance after input shaper and after extruder rotation distance is correct.

Klipper direct-drive tower example:

```klipper
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005
```

Slice Klipper's square tower with:

1. High speed, for example 100 mm/s.
2. Zero infill.
3. Coarse layer height, around 75% of nozzle diameter.
4. Dynamic acceleration control disabled.
5. Scarf seams disabled.

Calculate:

```text
pressure_advance = start + best_height * factor
```

Set it under `[extruder]`:

```klipper
pressure_advance: <calculated_value>
```

## 14. First layer and print validation

After all calibration:

1. Heat to normal print temperatures.
2. Run `G28`.
3. Run or load bed mesh.
4. Print a first-layer test.
5. Adjust with small Z offset changes only after the probe offset and bed mesh are known good.

Use `SAVE_CONFIG` only for calibration values that Klipper manages. For hand-edited config values, update the repository config and upload it.

## Recommended order summary

1. Safety checks: sensors, heaters, fans.
2. Endstop and probe input checks.
3. Stepper buzz and motor direction.
4. X/Y sensorless homing.
5. Klicky attach/dock movement.
6. Full `G28` with probe as Z endstop.
7. PID tune bed and hotend.
8. Extruder rotation distance.
9. `PROBE_CALIBRATE`.
10. Mechanical bed adjustment.
11. Heated `BED_MESH_CALIBRATE`.
12. `SHAPER_CALIBRATE`.
13. Pressure advance.
14. First-layer validation.
