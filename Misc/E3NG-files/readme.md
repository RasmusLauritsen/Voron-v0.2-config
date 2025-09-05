# Configuring RPi and SKR E3 Mini v3.0 for a E3NG
Flash Raspberry Pi with Raspbian OS Lite (64-bit)

```bash
sudo apt-get update && sudo apt-get install git python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev -y
cd ~ && git clone https://github.com/dw-0/kiauh.git
./kiauh/kiauh.sh
```


```bash
~/klippy-env/bin/pip install -v "numpy<1.26"
~/klippy-env/bin/python -c 'import numpy;'
```

Make sure the Linux SPI driver is enabled by running `sudo raspi-config` and enabling SPI under the "Interfacing options" menu.

Add this to printer.cfg
```klipper
[mcu btt_lis2dw]
serial: /dev/serial/by-id/usb-Klipper_rp2040_504450613079ED1C-if00

[lis2dw]
cs_pin: btt_lis2dw:gpio9
#spi_bus: spi1a
spi_software_sclk_pin: btt_lis2dw:gpio10
spi_software_mosi_pin: btt_lis2dw:gpio11
spi_software_miso_pin: btt_lis2dw:gpio8
axes_map: -y,x,-z

[resonance_tester]
probe_points: 100, 100, 20
accel_chip: lis2dw
```

Now run: `ACCELEROMETER_QUERY` to ensure it¨s connect correct