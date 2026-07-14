import QtQuick 2.0

Text {
    id: root
    
    property bool showHelpTips: false
    property bool fadeInComplete: false
    property int fadeInDuration: 300
    property real elementOpacity: 1.0
    
    visible: root.showHelpTips
    text: "F10 - sleep\nF11 - shutdown\nF12 - restart\nF2 - toggle password"
    color: colors.mutedText
    font.pixelSize: config.intValue("helpTipsFontSize") || 11
    font.family: colors.mainFont
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 20
    opacity: ((root.fadeInComplete ? 1 : 0) * root.elementOpacity)
    
    Behavior on opacity {
        NumberAnimation { duration: root.fadeInDuration; easing.type: Easing.OutCubic }
    }
}

