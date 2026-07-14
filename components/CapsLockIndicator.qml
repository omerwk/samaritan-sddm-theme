import QtQuick 2.0

Text {
    id: root
    
    property bool showCapsLockIndicator: false
    property bool capsLockActive: false
    property int animationDuration: 200
    property real elementOpacity: 1.0
    
    visible: root.showCapsLockIndicator && root.capsLockActive
    text: "CAPS LOCK"
    color: colors.triangleColor
    font.pixelSize: config.intValue("capsLockIndicatorFontSize") || 12
    font.family: colors.mainFont
    opacity: (root.visible ? 1 : 0) * root.elementOpacity
    
    Behavior on opacity {
        NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic }
    }
}

