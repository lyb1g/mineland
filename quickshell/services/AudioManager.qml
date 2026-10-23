pragma Singleton

import QtQuick
import QtMultimedia
import Quickshell

Singleton {
    id: root

    property bool soundsOn: Settings.soundsOn

    SoundEffect {
        id: click
        source: Quickshell.shellDir + "/assets/sfx/click.wav"
        volume: 1
    }

    function play(name) {
        if (!soundsOn) return
        if (name === "click") click.play()
    }
}