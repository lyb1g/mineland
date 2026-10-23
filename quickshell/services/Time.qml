pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    readonly property string time: Qt.formatDateTime(clock.date, "HH:mm")
    readonly property string date: Qt.formatDateTime(clock.date, "dddd, d MMMM")
}