pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme
import qs.services

Singleton {
    id: root

    readonly property string wallpaperDir: Settings.wallpapersDir ?? ""
    property var wallpapers: []

    Process {
        id: finder

        command: ["find", root.wallpaperDir, "-type", "f"]
        running: root.wallpaperDir !== ""
        
        stdout: StdioCollector {
            onStreamFinished: {
                let walls = text.trim().split("\n")
                root.wallpapers = walls
            }
        }
    }

    Process {
        id: writer
    }

    function setWallpaper(path) {
        writer.command = [
            "awww", 
            "img", 
            "--transition-type", Theme.awwwTransitionType, 
            "--transition-step", Theme.awwwTransitionStep, 
            "--transition-duration", Theme.awwwTransitionDuration,
            "--transition-bezier", Theme.awwwTransitionBezier,
            "--transition-fps", Theme.awwwTransitionFPS,
            "--transition-pos", "0.5,0.5",
            path
        ]
        writer.running = true
    }
}