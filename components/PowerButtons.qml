import QtQuick 2.0
import SddmComponents 2.0

Row {
    id: root
    
    spacing: config.intValue("selectorSpacing") || 10
    
    property int activeButton: -1 // -1 = none, 0 = shutdown, 1 = restart, 2 = suspend
    property bool fadeInComplete: true
    property int fadeInDuration: 300
    property real elementOpacity: 1.0
    
    property int selectorHeight: config.intValue("selectorHeight") || 35
    property int arrowWidth: config.intValue("selectorArrowWidth") || 30
    property int selectorRadius: config.intValue("selectorRadius") || 0
    property int containerWidth: parent ? parent.width : 0
    
    anchors.horizontalCenter: parent.horizontalCenter
    
    // Power button labels
    readonly property var buttonLabels: ["shutdown", "restart", "suspend"]
    readonly property string currentLabel: root.activeButton >= 0 && root.activeButton < buttonLabels.length ? buttonLabels[root.activeButton] : ""
    
    // Left arrow button
    Rectangle {
        width: root.arrowWidth
        height: root.selectorHeight
        radius: root.selectorRadius
        color: "transparent"

        Text {
            text: "<"
            color: colors.primaryText
            font.pixelSize: config.intValue("selectorArrowFontSize") || 17
            font.family: colors.mainFont
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (root.activeButton > 0) {
                    root.activeButton--
                } else {
                    root.activeButton = 2
                }
            }
        }
    }

    // Power action display
    Rectangle {
        width: root.containerWidth - (root.arrowWidth * 2) - (root.spacing * 2) - 200
        height: root.selectorHeight
        radius: root.selectorRadius
        color: "transparent"
        clip: true

        Text {
            text: root.currentLabel
            color: colors.primaryText
            font.pixelSize: config.intValue("selectorFontSize") || 14
            font.family: colors.mainFont
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }
    }

    // Right arrow button
    Rectangle {
        width: root.arrowWidth
        height: root.selectorHeight
        radius: root.selectorRadius
        color: "transparent"

        Text {
            text: ">"
            color: colors.primaryText
            font.pixelSize: config.intValue("selectorArrowFontSize") || 17
            font.family: colors.mainFont
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (root.activeButton < 2) {
                    root.activeButton++
                } else {
                    root.activeButton = 0
                }
            }
        }
    }
    
    // Handle Enter key to activate power action
    function activateCurrentButton() {
        if (root.activeButton === 0) {
            sddm.powerOff()
        } else if (root.activeButton === 1) {
            sddm.reboot()
        } else if (root.activeButton === 2) {
            sddm.suspend()
        }
    }
}
