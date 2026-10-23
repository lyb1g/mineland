pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    Process {
        id: runner
        running: false

        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                if (text === "") return
                Quickshell.execDetached(["notify-send", "-a", "", "", text])
            }
            // onError: Quickshell.execDetached(["notify-send", "-a", "", "", text])
        }
    }

    function runCommand(command) {
        if (command === "/clear") {
            Notifs.clearAll()
        } 
        
        else if (command.startsWith("/")) {
            runner.command = command.slice(1, command.length).split(" ")
            runner.running = true
        } 
        
        else {
            runner.command = ["notify-send", "-a", "", Quickshell.env("USER"), command.trim()]
            runner.running = true
        }
    }
}