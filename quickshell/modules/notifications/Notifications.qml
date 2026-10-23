import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.theme
import qs.components
import qs.services

PanelWindow {
    id: root
    
    readonly property bool chatOpen: Popups.chat

    onChatOpenChanged: {
        if (chatOpen) {
            commandField.text = ""
        }
    }

    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: chatOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    Region {
        id: nothing
    }
    mask: nothing
    color: "transparent"

    ScriptModel {
        id: popupsOnly
        values: Notifs.popups
    }

    ListView {
        id: listView
        height: 600
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        width: 1000
        verticalLayoutDirection: ListView.BottomToTop
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: {
            if (Notifs.list == null) return []

            if (root.chatOpen) return Notifs.list
            return popupsOnly
        }

        delegate: NotificationRow {
            width: 1000
            chatOpen: root.chatOpen
        }
    }

    Rectangle {
        visible: root.chatOpen
        anchors.bottom: parent.bottom
        x: 0
        width: parent.width
        height: 24
        color: Qt.alpha("#000000", 0.6)

        TextInput {
            id: commandField
            anchors.verticalCenter: parent.verticalCenter
            x: 8
            width: parent.width - 16
            clip: true
            focus: true
            color: "#FFFFFF"
            font.pixelSize: 16
            font.family: Theme.font
            Keys.onEscapePressed: Popups.closeAll()
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    event.accepted = true
                    if (text === "") return
                    Commands.runCommand(text)
                    text = ""
                }
            }
        }
    }
}