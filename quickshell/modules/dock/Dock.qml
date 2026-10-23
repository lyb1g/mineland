import QtQuick
import Quickshell
import qs.theme
import qs.services
import qs.components

PanelWindow {
    id: root

    anchors { bottom: true; left: true; right: true }
    color: "transparent"
    implicitHeight: 100
    exclusiveZone: 80
    mask: Region { item: dock }

    readonly property bool isCharging: Battery.charging

    Row {
        id: dock
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            anchors.fill: parent
            model: Apps.dockApps

            Rectangle {
                id: cell

                required property var modelData
                required property int index

                height: 50
                width: 50
                color: Theme.dockBg
                topRightRadius:    index === 8 ? 8 : 0
                topLeftRadius:     index === 0 ? 8 : 0
                bottomRightRadius: index === 8 ? 8 : 0
                bottomLeftRadius:  index === 0 ? 8 : 0
                border.color: Theme.dockOutline
                border.width: 2

                AppItem {
                    anchors.fill: parent
                    name: cell.modelData != undefined ? cell.modelData.name : ""
                    icon: cell.modelData != undefined ? cell.modelData.icon : ""
                    onClicked: {
                        AudioManager.play("click")
                        cell.modelData.execute()
                    }
                }
            }       
        }
    }

    Item {
        height: 20
        anchors.bottom: dock.top
        anchors.bottomMargin: 4
        anchors.left: dock.left
        anchors.right: dock.right

        Row {
            anchors.fill: parent

            Repeater {
                model: 10

                Item {
                    id: heartItem
                    required property int index

                    readonly property string image: {
                        if (root.isCharging && Settings.allGoldenWhenCharging) return "golden_heart.png"
                        if (Battery.percent * 10 > index) return root.isCharging ? "golden_heart.png" : "heart.png"
                        return "empty_heart.png"
                    }

                    width: 18
                    height: 20

                    Image {
                        anchors.fill: parent
                        source: Quickshell.shellDir + "/assets/images/" + heartItem.image
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }
    }
}