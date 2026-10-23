pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property var device: UPower.displayDevice
    readonly property bool present: device !== null && device.isPresent

    readonly property real percent: present ? device.percentage : 0
    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
}