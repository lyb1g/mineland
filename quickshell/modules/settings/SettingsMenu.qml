import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.theme
import qs.components
import qs.services

PanelWindow {
    id: settingsMenu

    readonly property bool open: Popups.settings

    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    color: "transparent"
    Region {
        id: nothing
    }
    mask: open ? null : nothing

    Shortcut {
        sequences: ["Esc"]
        onActivated: {
            Popups.closeAll()
            AudioManager.play("click")
        }
    }

    function getStateLabel(on) {
        return on ? "ON" : "OFF"
    }

    Rectangle {
        anchors.fill: parent
        color: "#77000000"
        opacity: settingsMenu.open ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: Theme.fadeTime }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 100
            text: "Settings"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 18
        }

        Column {
            y: 150
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 32
            width: 750

            Grid {
                width: parent.width
                spacing: 12
                columns: 2
                
                Button {
                    label: "SFX: " + settingsMenu.getStateLabel(Settings.soundsOn)
                    width: (parent.width - 12) / 2
                    onClicked: {
                        Settings.soundsOn = !Settings.soundsOn
                        Settings.save()
                    }
                }
                
                Button {
                    label: "Do not disturb: " + settingsMenu.getStateLabel(Settings.doNotDisturb)
                    width: (parent.width - 12) / 2
                    onClicked: {
                        Notifs.toggleDoNotDisturb()
                    }
                }
                
                Button {
                    label: "Full hearts when charging: " + settingsMenu.getStateLabel(Settings.allGoldenWhenCharging)
                    width: (parent.width - 12) / 2
                    onClicked: {
                        Settings.allGoldenWhenCharging = !Settings.allGoldenWhenCharging
                        Settings.save()
                    }
                }
            }
        }
    }
}