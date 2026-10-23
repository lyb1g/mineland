import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.theme
import qs.components
import qs.services

PanelWindow {
    id: launcher

    readonly property bool open: Popups.launcher
    readonly property string searchQuery: searchField.text
    readonly property var apps: Apps.search(searchQuery)

    property string currentTab: "Apps"

    property int selectedApp: 0 // HOVERED APP CONSIDERS AS SELECTED

    onOpenChanged: {
        AudioManager.play("click")
        if (open) {
            currentTab = "Apps"
            searchField.text = ""
        }
    }

    onCurrentTabChanged: {
        AudioManager.play("click")
    }

    onSearchQueryChanged: {
        selectedApp = 0
    }

    function openTab(name) {
        currentTab = name
    }

    function nextTab() {
        if (currentTab === "Apps") currentTab = "Wallpapers"
        else currentTab = "Apps"
    }
    
    anchors { top: true; left: true; right: true; bottom: true }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    Region {
        id: nothing
    }
    mask: open ? null : nothing
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Instantiator {
        model: 9

        delegate: Shortcut {
            required property int index

            sequence: "Ctrl+" + String(index + 1)
            onActivated: {
                if (launcher.selectedApp < 0) return
                Apps.putAppInCell(index, apps[launcher.selectedApp])
            }
        }
    }
    
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: {
            if (launcher.currentTab === "Wallpapers" && backdrop.containsMouse) return 0
            if (launcher.open) return 0.5
            return 0
        }
        Behavior on opacity {
            NumberAnimation { duration: Theme.fadeTime }
        }

        MouseArea {
            id: backdrop
            hoverEnabled: true
            anchors.fill: parent
        }
    }

    Row {
        id: tabsRow
        anchors.bottom: inventory.top
        anchors.left: inventory.left
        anchors.leftMargin: 12
        anchors.right: inventory.right
        spacing: 8
        opacity: inventory.opacity

        InventoryTab {
            active: launcher.currentTab === "Apps"
            icon: Quickshell.shellDir + "/assets/images/apps.png"
            onClicked: launcher.openTab("Apps")
        }
        
        InventoryTab {
            active: launcher.currentTab === "Wallpapers"
            icon: Quickshell.shellDir + "/assets/images/wallpapers.png"
            onClicked: launcher.openTab("Wallpapers")
        }
    }

    Rectangle {
        id: inventory
        anchors.centerIn: parent
        width: 482
        height: 380
        color: Theme.bg
        radius: 6
        border.color: "#000000"
        border.width: 2

        anchors.verticalCenterOffset: open ? 0 : 20
        Behavior on anchors.verticalCenterOffset {
            NumberAnimation {
                duration: Theme.fadeTime
                easing.type: Easing.OutCubic
            }
        }

        opacity: {
            if (launcher.currentTab === "Wallpapers" && backdrop.containsMouse) return 0.2
            if (open) return 1
            return 0
        }
        Behavior on opacity {
            NumberAnimation { duration: Theme.fadeTime }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
        }

        Text {
            x: 16
            y: 16
            text: {
                if (launcher.currentTab === "Apps") return "Search Apps"
                if (launcher.currentTab === "Wallpapers") return "Choose Wallpaper"
            }
            color: Theme.textGrey
            font.family: Theme.font
            font.pixelSize: 20
        }

        Rectangle {
            x: 216
            y: 8
            height: 32
            width: 250
            color: Theme.bg1
            visible: launcher.currentTab === "Apps"

            ShadowVLine {}
            ShadowHLine {}

            TextInput {
                id: searchField
                anchors.verticalCenter: parent.verticalCenter
                x: 8
                width: parent.width - 16
                focus: true
                color: Theme.text
                font.pixelSize: 18
                font.family: Theme.font
                clip: true
                Keys.onEscapePressed: Popups.closeAll()
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Tab) {
                        launcher.nextTab()
                        event.accepted = true
                    }
                }
            }
        }

        Item {
            x: 16
            width: 450
            y: 48
            height: 250
            visible: launcher.currentTab === "Apps" ? 1 : 0
           
            GridView {
                anchors.fill: parent
                model: {
                    // 1. Convert to array AND filter out null/undefined/broken entries
                    let rawApps = launcher.apps ? Array.from(launcher.apps) : []
                    let appsArray = rawApps.filter(app => app && Object.keys(app).length > 0)
                    
                    let currentLength = appsArray.length

                    // 2. Safely calculate padding for 9-column rows (Minimum 45 items)
                    let toCompleteRow = (9 - (currentLength % 9)) % 9
                    let totalWithRow = currentLength + toCompleteRow
                    let toReachMinimum = Math.max(0, 45 - totalWithRow)
                    let totalPadding = toCompleteRow + toReachMinimum
                    
                    // 3. Combine valid apps with empty spacer nodes
                    let paddingArray = Array.from({ length: totalPadding }, () => ({}))
                    return appsArray.concat(paddingArray)
                }

                cellWidth: 50
                cellHeight: 50
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                delegate: Rectangle {
                    id: cell

                    required property var modelData
                    required property int index

                    color: Theme.bg1
                    border.color: Theme.outline
                    border.width: 2
                    width: 50
                    height: 50

                    ShadowVLine {}
                    ShadowHLine {}
                    
                    AppItem {
                        readonly property bool notEmpty: cell.modelData != null && cell.modelData.name !== undefined

                        visible: notEmpty
                        anchors.fill: parent
                        name: notEmpty ? cell.modelData.name : ""
                        comment: notEmpty ? cell.modelData.comment : ""
                        icon: notEmpty ? cell.modelData.icon : ""
                        onClicked: {
                            Popups.toggleLauncher()
                            cell.modelData.execute()
                        }
                    }

                    HoverHandler {
                        onHoveredChanged: if (hovered) launcher.selectedApp = cell.index
                    }
                }
            }
        }

        WallpaperSwitcher {
            visible: launcher.currentTab === "Wallpapers" ? 1 : 0
        }

        Row {
            x: 16
            y: 314
            width: parent.width - 16
            height: 50

            Repeater {
                model: Apps.dockApps

                delegate: Rectangle {
                    id: dockCell

                    required property var modelData

                    color: Theme.bg1
                    border.color: Theme.outline
                    border.width: 2
                    width: 50
                    height: 50

                    ShadowVLine {}
                    ShadowHLine {}
                    
                    AppItem {
                        readonly property bool notEmpty: dockCell.modelData != null && dockCell.modelData.name !== undefined

                        visible: notEmpty
                        anchors.fill: parent
                        name: notEmpty ? dockCell.modelData.name : ""
                        comment: notEmpty ? dockCell.modelData.comment : ""
                        icon: notEmpty ? dockCell.modelData.icon : ""
                        onClicked: {
                            Popups.toggleLauncher()
                            dockCell.modelData.execute()
                        }
                    }
                }
            }
        }
    }
}