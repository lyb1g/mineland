import QtQuick
import QtQuick.Effects
import qs.components
import qs.theme
import qs.services

Rectangle {
    id: button
    
    property string label: ""

    signal clicked()

    color: Theme.buttonBg
    height: 40
    border.color: "#303030"

    Text {
        anchors.centerIn: parent
        text: button.label
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 18

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#555555"
            shadowBlur: 0
            shadowHorizontalOffset: 3
            shadowVerticalOffset: 3
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            AudioManager.play("click")
            button.clicked()
        }
    }

    OutterVBlick {}
    OutterHBlick {}
    OutterVShadow {}
    OutterHShadow {}
}