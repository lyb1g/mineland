pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
    id: root
    
    readonly property var allApps: {
        let apps = DesktopEntries.applications.values.slice()
        apps.sort((a, b) => a.name.localeCompare(b.name))
        return apps
    } 

    readonly property var dockApps: Settings.dockApps.map(id => allApps.find(app => app.id === id))

    function search(query) {
        let needle = query.toLowerCase()
        return allApps.filter(app => (app.name + " " + app.comment).toLowerCase().includes(query))
    }

    function putAppInCell(index, app) {
        let newList = Settings.dockApps.slice()
        newList[index] = app.id
        Settings.dockApps = newList
        Settings.save()
    }
}