import QtQuick
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.dock
import qs.modules.launcher
import qs.modules.power_menu
import qs.modules.settings
import qs.modules.notifications
import qs.modules.desktop

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Scope {
            id: perScreen
            required property var modelData

            Dock { screen: perScreen.modelData }
            Launcher { screen: perScreen.modelData }
            PowerMenu { screen: perScreen.modelData }
            SettingsMenu { screen: perScreen.modelData }
            Notifications { screen: perScreen.modelData }
            Desktop { screen: perScreen.modelData }
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            Popups.toggleLauncher()
        }
    }
    
    IpcHandler {
        target: "power"

        function toggle(): void {
            Popups.togglePowerMenu()
            AudioManager.play("click")
        }
    }
    
    IpcHandler {
        target: "settings"

        function toggle(): void {
            Popups.toggleSettings()
            AudioManager.play("click")
        }
    }

    IpcHandler {
        target: "chat"

        function toggle(): void {
            Popups.toggleChat()
            Notifs.hideAllPopups()
        }

        function clearAll(): void {
            Notifs.clearAll()
        }
    }
}