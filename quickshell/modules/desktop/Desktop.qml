import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.theme
import qs.components
import qs.services

PanelWindow {
    id: desktop

    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayershell.Bottom
    color: "transparent"
    mask: Region {}

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 500
        height: 200
        y: 150

        Column {
            anchors.fill: parent

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Time.time
                font {
                    family: Theme.font
                    pixelSize: 100
                }
                color: Theme.text
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Time.date
                font {
                    family: Theme.font
                    pixelSize: 24
                }
                color: Theme.text
            }
        }
    }
}