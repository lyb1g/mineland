pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    property alias dockApps: saved.dockApps
    property alias soundsOn: saved.soundsOn
    property alias doNotDisturb: saved.doNotDisturb
    property alias allGoldenWhenCharging: saved.allGoldenWhenCharging
    property alias wallpapersDir: saved.wallpapersDir

    FileView {
        id: file
        path: Quickshell.shellDir + "/config.json"
        blockLoading: true

        JsonAdapter {
            id: saved
            property var dockApps: []
            property bool soundsOn: true
            property bool doNotDisturb: false
            property bool allGoldenWhenCharging: false
            property string wallpapersDir: ""
        }
    }

    function save() {
        file.writeAdapter()
    }
}