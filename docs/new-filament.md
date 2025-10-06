# Calibrate new filament
Do this for at least each filament type, prefably for each brand.

## Pressure Advance (per filament type)
Documentation: https://ellis3dp.com/Print-Tuning-Guide/articles/pressure_linear_advance/pattern_method.html

Set a value per filament - at least if it differs from your "normal" filament, which is tuned in printer.cfg.

Example for my eSUN ABS+ - set this in the filament gcode.
PrusaSlicer: `Filaments`-> `Custom G-code` -> `Start G-code`.

```G-Code
SET_PRESSURE_ADVANCE ADVANCE=0.04
```

## Flow calibration (per filament type)
Documentation:
- https://ellis3dp.com/Print-Tuning-Guide/articles/extrusion_multiplier.html

## Retraction settings (Orca Slicer calibration) - Per filament
