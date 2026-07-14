import QtQuick 2.0

Text {
    id: root
    
    property string previewText: ""
    property bool showPreview: false
    property string activeSelector: ""
    property string hideWhenSelector: ""
    property bool fadeInComplete: false
    property int animationDuration: 200
    property real elementOpacity: 1.0
    
    text: "["+root.previewText+"]"
    color: colors.mutedText
    font.pixelSize: config.intValue("selectorPreviewFontSize") || 11
    font.family: colors.mainFont
    visible: root.showPreview && root.activeSelector !== root.hideWhenSelector && root.previewText !== ""
    opacity: ((root.visible && root.fadeInComplete) ? 1 : 0) * root.elementOpacity
    
    
    Behavior on opacity {
        NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic }
    }
}

