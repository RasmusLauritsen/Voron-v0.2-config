# Klicky Upstream Changes

This directory contains macros from:

https://github.com/jlas1/Klicky-Probe/tree/main/Klipper_macros

If these files are refreshed from upstream, re-apply the local changes below.

## Files intentionally changed

### `klicky-probe.cfg`

Enable the Klicky bed mesh wrapper:

```ini
[include ./klicky-bed-mesh-calibrate.cfg]
```

Upstream leaves this line commented out. This printer uses the Klicky wrapper so
`BED_MESH_CALIBRATE` automatically attaches and docks the probe.

### `klicky-macros.cfg`

#### `PROBE_CALIBRATE`

The local version moves to the computed bed-center probe point before starting
calibration.

With the current V0 bed and probe offsets:

```text
probe target: X60 Y60
toolhead:     X76 Y44
```

This avoids starting calibration from wherever `G28` or probe docking left the
toolhead.

#### `PROBE_ACCURACY`

The local version makes these parameters useful:

```gcode
PROBE_ACCURACY X=60 Y=60 Z=12
```

Local behavior:

- `X` and `Y` are treated as probe contact coordinates on the bed.
- The macro converts those into toolhead coordinates using the configured probe
  offsets.
- `Z` is used as the pre-probe travel height.
- `X`, `Y`, and `Z` are stripped before forwarding to Klipper's native
  `_PROBE_ACCURACY`.

With the current probe offsets:

```ini
x_offset: -16
y_offset: 16
```

This command:

```gcode
PROBE_ACCURACY X=60 Y=60 Z=12 SAMPLES=10 SAMPLE_RETRACT_DIST=2
```

moves the toolhead to:

```text
X76 Y44 Z12
```

so the probe itself is over:

```text
X60 Y60
```

## Files not functionally changed

The following files should match upstream functionally. Differences may appear
from line endings or missing trailing newlines only.

- `klicky-bed-mesh-calibrate.cfg`
- `klicky-screws-tilt-calculate.cfg`
- `klicky-z-tilt-adjust.cfg`
- `klicky-quad-gantry-level.cfg`
- `klicky-specific.cfg`

## Variables

This note does not document `klicky-variables.cfg`. That file is expected to be
printer-specific.
