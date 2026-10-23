import QtQuick
import qs.components
import qs.theme
import qs.services

Item {
    x: 16
    width: 450
    y: 48
    height: 250

    GridView {
        id: wallGrid
        anchors.fill: parent
        cellWidth: parent.width / 2
        cellHeight: cellWidth / 16 * 9
        model: Wallpapers.wallpapers
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        delegate: Item {
            required property string modelData
            
            width: wallGrid.cellWidth
            height: wallGrid.cellHeight


            Image {
                anchors.fill: parent
                source: modelData
                fillMode: Image.PreserveAspectCrop

                sourceSize.width: wallGrid.cellWidth
                sourceSize.height: wallGrid.cellHeight

                asynchronous: true
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Theme.outline
                border.width: 2
            }

            ShadowHLine {}
            ShadowVLine {}

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onPressed: {
                    AudioManager.play("click")
                    Wallpapers.setWallpaper(modelData)
                }
            }
        }
    }
}