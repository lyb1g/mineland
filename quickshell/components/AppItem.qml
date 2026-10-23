import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

Item {
    id: app

    property string name: ""
    property string comment: ""
    property string icon: ""

    signal clicked()

    Item {
        anchors.centerIn: parent
        width: 38
        height: 38
        scale: mouse.pressed ? 0.9 : 1
        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
        
        Image {
            anchors.fill: parent
            source: Quickshell.iconPath(app.icon, true)
            sourceSize.width: 46 
            sourceSize.height: 46
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        drag.target: app

        onClicked: app.clicked()
    }

    ToolTip {
        visible: mouse.containsMouse
        text: app.name + "\n" + app.comment
        delay: 1000
    }

}