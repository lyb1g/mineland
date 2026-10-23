pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property color bg: "#c6c6c6"
    readonly property color text: "#FFFFFF"
    readonly property color textGrey: "#3a3a3a"
    readonly property color bg1: "#8b8b8b"
    readonly property color dockBg: "#88888888"
    readonly property color dockOutline: "#88FFFFFF"
    readonly property color outline: "#FFFFFF"
    readonly property color buttonBg: "#707070"

    readonly property int fadeTime: 150
    readonly property int slideTime: 250

    readonly property string font: "Minecraft"

    readonly property string awwwTransitionType: "grow" // simple, grow, bezier
    readonly property string awwwTransitionBezier: "0.65,0,0.35,1" // EaseInOut
    readonly property real awwwTransitionDuration: 1
    readonly property int awwwTransitionStep: 20
    readonly property int awwwTransitionFPS: 120
}