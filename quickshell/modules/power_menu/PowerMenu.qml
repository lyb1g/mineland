import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.theme
import qs.services

PanelWindow {
    id: powerMenu

    readonly property bool open: Popups.powerMenu

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

    Rectangle {
        anchors.fill: parent
        color: "#77000000"
        opacity: powerMenu.open ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: Theme.fadeTime }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 100
            text: "Game Menu"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 18
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.25
            width: 450
            spacing: 12

            Button {
                label: "Back to Game"
                width: parent.width
                onClicked: Popups.closeAll()
            }

            Grid {
                width: parent.width
                spacing: 12
                columns: 2

                Button {
                    label: "Log Out"
                    width: (parent.width - 12) / 2
                    onClicked: Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.exit()"])
                }
                
                Button {
                    label: "Suspend"
                    width: (parent.width - 12) / 2
                    onClicked: Quickshell.execDetached(["systemctl", "suspend"])
                }
                
                Button {
                    label: "Options..."
                    width: (parent.width - 12) / 2
                    onClicked: Popups.toggleSettings()
                }
                
                Button {
                    label: "Reboot"
                    width: (parent.width - 12) / 2
                    onClicked: Quickshell.execDetached(["systemctl", "reboot"])
                }
            }

            Button {
                label: "Save and shut down"
                width: parent.width
                onClicked: Quickshell.execDetached(["systemctl", "poweroff"])
            }
        }
    }
}