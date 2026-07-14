import QtQuick 2.0

Rectangle {
    id: root

    property alias passwordInput: passwordInput
    property alias passwordText: passwordInput.text
    property bool enabled: true
    property bool fadeInComplete: true
    property int fadeInDuration: 300
    property real elementOpacity: 1
    property bool hasError: false
    property bool showPasswordButton: config.boolValue("showPasswordButton") || false
    property bool passwordVisible: false
    property int animationDuration: config.intValue("animationDuration") || 200

    signal loginRequested()

    clip: true
    antialiasing: true
    width: config.intValue("passwordFieldWidth") || 200
    height: config.intValue("passwordFieldHeight") || 25
    color: colors.background
    border.color: colors.background
    opacity: (root.fadeInComplete ? 1 : 0) * root.elementOpacity

    Item {
        anchors.fill: parent
        
        TextInput {
            id: passwordInput

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: parent.width
            height: parent.height
            color: colors.primaryText
            echoMode: root.passwordVisible ? TextInput.Normal : TextInput.Password
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignHCenter
            font.pixelSize: config.intValue("passwordFieldFontSize") || 16
            font.family: colors.mainFont
            font.letterSpacing: config.intValue("passwordFieldLetterSpacing") || 2
            passwordCharacter: {
                var maskChar = config.stringValue("passwordCharacter");
                return (maskChar && maskChar !== "") ? maskChar : "*";
            }
            selectByMouse: false
            selectionColor: "transparent"
            enabled: root.enabled
            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    root.loginRequested();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                    event.accepted = false;
                }
            }

            cursorDelegate: Rectangle {
                width: 2
                height: 10
                anchors.verticalCenter: parent.verticalCenter
                color: colors.primaryText

                SequentialAnimation on opacity {
                    running: true
                    loops: Animation.Infinite

                    NumberAnimation {
                        to: 0
                        duration: 500
                    }

                    NumberAnimation {
                        to: 1
                        duration: 500
                    }

                }

            }

        }

        MouseArea {
            id: showPasswordButtonArea

            visible: root.showPasswordButton
            width: root.showPasswordButton ? 24 : 0
            height: 24
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                root.passwordVisible = !root.passwordVisible;
            }

            Text {
                anchors.centerIn: parent
                text: root.passwordVisible ? "◉" : "○"
                color: colors.primaryText
                font.pixelSize: 16
                font.family: colors.mainFont
            }

        }

    }

    Behavior on opacity {
        NumberAnimation {
            duration: root.fadeInDuration
            easing.type: Easing.OutCubic
        }

    }

}
