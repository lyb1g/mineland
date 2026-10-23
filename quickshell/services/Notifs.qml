pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property var list: server.trackedNotifications.values.slice().reverse()
    property var popups: []

    property bool doNotDisturb: Settings.doNotDisturb

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true

            if (!root.doNotDisturb) root.popups = [notif].concat(root.popups)
        }
    }

    function hideAllPopups() {
        popups = []
    }

    function hidePopup(notif) {
        popups = popups.filter(p => p !== notif)
    }

    function clearAll() {
        for (let notif of list) {
            notif.dismiss()
        }
    }

    function toggleDoNotDisturb() {
        Settings.doNotDisturb = !Settings.doNotDisturb
        Settings.save()
    }
}