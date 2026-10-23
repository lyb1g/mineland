pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property bool launcher: false
    property bool powerMenu: false
    property bool settings: false
    property bool chat: false
    
    function closeAll() {
        launcher = false
        powerMenu = false
        settings = false
        chat = false
    }

    function toggleLauncher() {
        if (launcher) {
            launcher = false
        } else {
            closeAll()
            launcher = true
        }
    }
    
    function togglePowerMenu() {
        if (powerMenu) {
            powerMenu = false
        } else {
            closeAll()
            powerMenu = true
        }
    }

    function toggleSettings() {
        if (settings) {
            settings = false
        } else {
            closeAll()
            settings = true
        }
    }

    function toggleChat() {
        if (chat) {
            chat = false
        } else {
            closeAll()
            chat = true
        }
    }
}