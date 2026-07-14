import QtQuick 2.0
import "."

Item {
    id: root
    
    property string activeSelector: ""
    property string selectorType: "" // "user", "session", "power"
    property int selectorHeight: 40
    property int animationDuration: 200
    property real elementOpacity: 1.0
    property int elementSpacing: 15
    
    property alias content: contentLoader.sourceComponent
    
    width: parent ? parent.width : 0
    height: (root.activeSelector === root.selectorType) ? root.selectorHeight : 0
    clip: true
    opacity: root.elementOpacity
    
    Behavior on height {
        NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic }
    }
    
    Loader {
        id: contentLoader
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
}

