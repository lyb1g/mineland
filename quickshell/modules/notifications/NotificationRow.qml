import QtQuick
import qs.theme
import qs.components
import qs.services
import "../../scripts/AnsiConverter.js" as AnsiConverter

Rectangle {
    id: message

    readonly property bool notEmpty: modelData != null

    property bool shown: true
    property bool chatOpen: false

    required property var modelData
    property var notification: modelData

    readonly property string summary: notEmpty ? notification.summary !== "" ? notification.summary + ": " : "" : ""
    readonly property string rawOutput: notEmpty ? summary + String(message.notification.body || "").replace("\n", " ") : ""

    height: content.height + 4

    Timer {
        id: fadeOut
        interval: 3000
        running: false
        repeat: false
        
        onTriggered: shown = false
    }

    Component.onCompleted: if (!message.chatOpen) fadeOut.start()

    color: Qt.alpha("#000000", 0.6)

    opacity: shown ? 1 : 0
    Behavior on opacity {
        NumberAnimation { 
            duration: 500

            onRunningChanged: {
                if (!running) Notifs.hidePopup(notification)
            }
        }
    }

    Text {
        id: content
        anchors.verticalCenter: parent.verticalCenter
        x: 12
        width: parent.width - 24

        text: "<pre style='margin: 0; white-space: pre;'>" + AnsiConverter.parseTerminalOutput(message.rawOutput) + "</pre>"
        color: "#FFFFFF"
        font.pixelSize: 16
        font.family: Theme.font
        textFormat: Text.StyledText
        wrapMode: Text.WordWrap
    }
}
