import QtQuick
import qs.theme
import qs.components

Rectangle {
    id: tab

    property bool active: false
    property string icon: ""

    signal clicked()

    width: 58
    height: 50
    radius: 6
    color: active ? Theme.bg : Theme.bg1
    
    OutterHBlick {
        height: 4
    }
    OutterVBlick {
        width: 4
    }
    OutterVShadow {
        width: 4
    }

    Image {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 2
        source: tab.icon
        width: 40
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: tab.clicked()
    }
}