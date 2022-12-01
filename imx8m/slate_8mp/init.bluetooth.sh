#! /vendor/bin/sh

# If the SOM revision is V1.1, Bluetooth is over UART: default HAL works fine
if fgrep -q V1.1 /proc/device-tree/toradex,board-rev ; then
    echo "Bluetooth over UART, exiting";
    exit;
fi

# On SOM V1.0, the BTLinux HAL needs to be used
# Stop the NXP Bluetooth HAL and manually start the AOSP BTLinux HAL
stop vendor.bluetooth-1-0
/vendor/bin/hw/android.hardware.bluetooth@1.0-service.btlinux
