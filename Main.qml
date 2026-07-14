import QtQuick 2.0
import SddmComponents 2.0
import "components"
import "utils/ConfigManager.js" as ConfigManager
import "utils/NavigationHandler.js" as NavigationHandler
import "utils/SystemInfo.js" as SystemInfo

Rectangle {
    id: mainRect

    property string activeSelector: "password" // "password", "user", "session", "power"
    property int activePowerButton: 0 // 0=shutdown, 1=restart, 2=suspend
    property bool capsLockActive: false // capslock button bool
    // boot and interface properties
    property bool titleVisible: false
    property int bootStage: -1
    property bool bootComplete: false
    property bool interfaceReady: false
    property bool panelsVisible: false
    property bool loginVisible: false
    property bool samaritanVisible: false
    property bool loginSuccessful: false
    property int osAgeSeconds: SystemInfo.os_age_seconds // OS Age
    property string backgroundImage: config.stringValue("backgroundImage") || "" // background image
    property string currentTime: "" // system clock
    property int threatsIdentified: randomInt(1000, 99999) // threats identified counter
    property int animationDuration: config.intValue("animationDuration") || 200
    property int fadeInDuration: config.intValue("fadeInDuration") || 300
    property int elementSpacing: config.intValue("elementSpacing") || 15
    property bool showPreview: config.boolValue("showSelectorPreview") || false
    property bool showHelpTips: config.boolValue("showHelpTips") || false
    property bool showCapsLockIndicator: config.boolValue("showCapsLockIndicator") || false
    property bool allowEmptyPassword: config.boolValue("allowEmptyPassword") || false
    property bool clearPasswordOnError: config.boolValue("clearPasswordOnError") !== false
    property int passwordFieldOffsetX: config.intValue("passwordFieldOffsetX") || 0
    property int passwordFieldOffsetY: config.intValue("passwordFieldOffsetY") || 0
    property real elementOpacity: ConfigManager.getElementOpacity(config)
    // Fade-in animation state
    property bool fadeInComplete: false

    function formatOsAge() {
        var seconds = osAgeSeconds;
        var days = Math.floor(seconds / 86400);
        seconds %= 86400;
        var hours = Math.floor(seconds / 3600);
        seconds %= 3600;
        var minutes = Math.floor(seconds / 60);
        seconds %= 60;
        return (("0000" + days).slice(-4) + ":" + ("00" + hours).slice(-2) + ":" + ("00" + minutes).slice(-2) + ":" + ("00" + seconds).slice(-2));
    }

    // generate dots function
    function dots(count) {
        var result = "";
        for (var i = 0; i < count; i++) {
            result += ".";
        }
        return result;
    }

    function randomInt(min, max) {
        // generates a random integar in the range of min and max, required for threats identified counter
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    // Navigation functions
    function activatePowerButton() {
        if (mainRect.activeSelector === "power" && powerButtons)
            powerButtons.activateCurrentButton();

    }

    function returnToPassword() {
        mainRect.activeSelector = "password";
        passwordField.passwordInput.focus = true;
    }

    function navigateSelector(selector, direction) {
        return NavigationHandler.navigateSelector(selector, direction, userSelect, sessionSelect);
    }

    // Config properties
    color: config.stringValue("background") || colors.background
    focus: true
    Component.onCompleted: {
        fadeInComplete = true;
        passwordField.passwordInput.focus = true;
    }
    // Keyboard event handler
    Keys.onPressed: function(event) {
        var handled = false;
        // Track Caps Lock state
        if (event.key === Qt.Key_CapsLock) {
            mainRect.capsLockActive = !mainRect.capsLockActive;
            return ;
        } 
        if (event.key === Qt.Key_F2) {
            passwordField.passwordVisible = !passwordField.passwordVisible;
            handled = true;
        }
        if (event.key === Qt.Key_Up) {
            if (mainRect.activeSelector === "password") {
                mainRect.activeSelector = "user";
                mainRect.focus = true;
                handled = true;
            } else if (mainRect.activeSelector === "power") {
                mainRect.activeSelector = "session";
                mainRect.focus = true;
                handled = true;
            } else if (mainRect.activeSelector === "session") {
                returnToPassword();
                handled = true;
            } else if (mainRect.activeSelector === "user") {
                handled = false;
            } else {
                returnToPassword();
                handled = true;
            }
        } else if (event.key === Qt.Key_Down) {
            if (mainRect.activeSelector === "password") {
                mainRect.activeSelector = "session";
                mainRect.focus = true;
                handled = true;
            } else if (mainRect.activeSelector === "session") {
                mainRect.activeSelector = "power";
                mainRect.activePowerButton = 0;
                mainRect.focus = true;
                handled = true;
            } else if (mainRect.activeSelector === "power") {
                handled = false;
            } else {
                returnToPassword();
                handled = true;
            }
        } else if (event.key === Qt.Key_Left) {
            if (mainRect.activeSelector === "user") {
                handled = navigateSelector("user", "left");
            } else if (mainRect.activeSelector === "session") {
                handled = navigateSelector("session", "left");
            } else if (mainRect.activeSelector === "power") {
                var newButton = NavigationHandler.navigatePowerButton("left", powerButtons, mainRect.activePowerButton);
                if (newButton !== false)
                    mainRect.activePowerButton = newButton;

                handled = true;
            }
        } else if (event.key === Qt.Key_Right) {
            if (mainRect.activeSelector === "user") {
                handled = navigateSelector("user", "right");
            } else if (mainRect.activeSelector === "session") {
                handled = navigateSelector("session", "right");
            } else if (mainRect.activeSelector === "power") {
                var newButton = NavigationHandler.navigatePowerButton("right", powerButtons, mainRect.activePowerButton);
                if (newButton !== false)
                    mainRect.activePowerButton = newButton;

                handled = true;
            }
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (mainRect.activeSelector === "power") {
                activatePowerButton();
                handled = true;
            }
        } else if (event.key === Qt.Key_F10) {
            sddm.suspend();
            handled = true;
        } else if (event.key === Qt.Key_F11) {
            sddm.powerOff();
            handled = true;
        } else if (event.key === Qt.Key_F12) {
            sddm.reboot();
            handled = true;
        }
        if (handled)
            event.accepted = true;

    }

    // Colors object, to use Colors.qml
    Colors {
        id: colors
    }

    // uptime timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: osAgeSeconds++
    }

    // boot timer and text
    Timer {
        id: bootTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            bootStage++;
            if (bootStage >= 4) {
                bootTimer.stop();
                bootComplete = true;
                interfaceTimer.start();
            }
        }
    }

    // interface timers
    Timer {
        id: interfaceTimer

        interval: 1000
        repeat: false
        onTriggered: {
            interfaceReady = true;
        }
    }

    // interface ready stage 1, title
    Timer {
        interval: 0
        running: interfaceReady
        repeat: false
        onTriggered: {
            titleVisible = true;
        }
    }

    // interface ready stage 2, right and left panels
    Timer {
        interval: 300
        running: interfaceReady
        repeat: false
        onTriggered: {
            panelsVisible = true;
        }
    }

    // interface ready stage 3, samaritan prompt
    Timer {
        interval: 600
        running: interfaceReady
        repeat: false
        onTriggered: {
            samaritanVisible = true;
        }
    }

    // interface ready stage 4 and final, login interface
    Timer {
        interval: 800
        running: interfaceReady
        repeat: false
        onTriggered: {
            loginVisible = true;
        }
    }

    // system loading text
    Text {
        id: bootText

        text: {
            var core = "CORE INITIALIZATION " + dots(10) + " COMPLETE";
            var network = "NETWORK INTERFACE " + dots(12) + " CONNECTED";
            var govfeeds = "GOVERNMENT FEEDS " + dots(13) + " ACTIVE";
            if (bootStage === 0)
                return core;
            else if (bootStage === 1)
                return core + "\n\n" + network;
            else if (bootStage === 2)
                return core + "\n\n" + network + "\n\n" + govfeeds;
            else if (bootStage === 3)
                return core + "\n\n" + network + "\n\n" + govfeeds;
            else
                return "";
        }
        font.family: colors.mainFont
        font.pointSize: 10
        color: colors.bootText
        anchors.centerIn: parent
        opacity: bootComplete ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: 600
            }

        }

    }

    // system online text
    Text {
        id: systemOnlineText

        text: "SYSTEM ONLINE"
        font.family: colors.mainFont
        font.pointSize: 10
        color: colors.onlineText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: bootText.bottom
        anchors.topMargin: 40
        opacity: bootStage == 3 ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 800
            }

        }

    }

    // Background image
    Image {
        id: backgroundImageComponent

        anchors.fill: parent
        source: mainRect.backgroundImage
        fillMode: Image.PreserveAspectCrop
        visible: mainRect.backgroundImage !== ""
    }

    // system time timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            currentTime = Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss");
        }
    }

    // title text
    Text {
        text: "SAMARITAN v1.2.951.04"
        font.family: colors.samaritanFont
        font.pointSize: 20
        y: parent.height / 2 - 500
        anchors.left: parent.left
        anchors.leftMargin: 40
        color: colors.primaryText
        opacity: titleVisible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }

        }

    }

    // system time text
    Text {
        text: "SYSTEM TIME\n" + currentTime
        font.family: colors.mainFont
        font.pointSize: 9
        color: colors.secondaryText
        y: parent.height / 2 - 450
        anchors.left: parent.left
        anchors.leftMargin: 40
        opacity: titleVisible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }

        }

    }

    // system status panel
    Column {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40
        anchors.bottomMargin: 45
        spacing: 8
        opacity: panelsVisible ? 1 : 0

        // Header
        Text {
            text: "SYSTEM STATUS\n"
            font.family: colors.headerFont
            font.pointSize: 10
            color: colors.headerText
        }

        // Status table
        Column {
            spacing: 2

            Row {
                spacing: 25

                Text {
                    width: 150
                    text: "CORE"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: SystemInfo.cpu
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Row {
                spacing: 25

                Text {
                    width: 150
                    text: "NETWORK"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: SystemInfo.hostname
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Row {
                spacing: 25

                Text {
                    width: 150
                    text: "GOVERNMENT FEEDS"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: SystemInfo.kernel + "\n"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

        }

        // Spacer
        Item {
            height: 8
        }

        // Uptime
        Text {
            text: "UPTIME"
            font.family: colors.headerFont
            font.pointSize: 10
            color: colors.headerText
        }

        Text {
            text: formatOsAge()
            font.family: colors.mainFont
            font.pointSize: 9
            color: colors.secondaryText
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }

        }

    }

    // makes threats identified counter go up every 2 seconds
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            threatsIdentified += randomInt(1, 20);
        }
    }

    // system information panel
    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 40
        anchors.topMargin: 45
        spacing: 8
        opacity: panelsVisible ? 1 : 0

        // Header
        Text {
            text: "SYSTEM PROFILE\n"
            font.family: colors.headerFont
            font.pointSize: 10
            color: colors.headerText
        }

        // Information
        Column {
            spacing: 2

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "NODE"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: "PRIMARY"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "INSTANCE"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: "SAMARITAN"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "VERSION"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: "1.2.951.04\n"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Item {
                height: 8
            }

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "MODE"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: "MONITORING"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "PLATFORM"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: SystemInfo.os
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "ARCHITECTURE"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: SystemInfo.architecture + "\n"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Item {
                height: 8
            }

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "THREAT ANALYSIS"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: "ACTIVE"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

            Row {
                spacing: 25

                Text {
                    width: 140
                    text: "THREATS IDENTIFIED"
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.mutedText
                }

                Text {
                    text: threatsIdentified
                    font.family: colors.mainFont
                    font.pointSize: 9
                    color: colors.secondaryText
                }

            }

        }

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }

        }

    }

    // Help tips
    HelpTips {
        id: helpTips

        showHelpTips: mainRect.showHelpTips
        fadeInComplete: mainRect.fadeInComplete
        fadeInDuration: mainRect.fadeInDuration
        elementOpacity: mainRect.elementOpacity
        opacity: panelsVisible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }

        }

    }

    SamaritanPrompt {
        id: samaritanPrompt

        active: samaritanVisible
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -280
        opacity: samaritanVisible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }

        }

    }

    // login area div
    Item {
        id: loginArea

        anchors.fill: parent
        opacity: loginVisible ? 1 : 0

        // User preview
        SelectorPreview {
            id: userPreview

            previewText: userSelect.selectedUser
            showPreview: mainRect.showPreview
            activeSelector: mainRect.activeSelector
            hideWhenSelector: "user"
            fadeInComplete: mainRect.fadeInComplete
            animationDuration: mainRect.animationDuration
            elementOpacity: mainRect.elementOpacity
            anchors.horizontalCenter: passwordField.horizontalCenter
            anchors.bottom: passwordField.top
            anchors.bottomMargin: config.intValue("selectorPreviewMargin") || 10
        }

        // User selector container
        Item {
            id: userSelectContainer

            width: passwordField.width
            height: mainRect.activeSelector === "user" ? (config.intValue("selectorHeight") || 35) : 0
            anchors.horizontalCenter: passwordField.horizontalCenter
            anchors.bottom: passwordField.top
            anchors.bottomMargin: mainRect.elementSpacing
            clip: true
            opacity: mainRect.elementOpacity

            UserSelect {
                id: userSelect

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: (mainRect.activeSelector === "user" ? 1 : 0) * mainRect.elementOpacity
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: mainRect.animationDuration
                        easing.type: Easing.OutCubic
                    }

                }

            }

            Behavior on height {
                NumberAnimation {
                    duration: mainRect.animationDuration
                    easing.type: Easing.OutCubic
                }

            }

        }

        // Password field
        PasswordField {
            id: passwordField

            width: 400
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: mainRect.passwordFieldOffsetX
            anchors.verticalCenterOffset: mainRect.passwordFieldOffsetY
            enabled: mainRect.activeSelector === "password"
            fadeInComplete: mainRect.fadeInComplete
            fadeInDuration: mainRect.fadeInDuration
            elementOpacity: mainRect.elementOpacity
            onLoginRequested: {
                var savedPassword = passwordField.passwordText;
                if (!mainRect.allowEmptyPassword && savedPassword.length === 0)
                    return ;

                sddm.login(userSelect.selectedUser, savedPassword, sessionSelect.selectedIndex);
                loginErrorTimer.start();
            }
        }

        Timer {
            id: loginErrorTimer

            interval: config.intValue("loginErrorDelay") || 500
            onTriggered: {
                if (!mainRect.loginSuccessful) {
                    passwordField.hasError = true;
                    samaritanPrompt.showAuthorizationFailed();
                    if (mainRect.clearPasswordOnError)
                        passwordField.passwordText = "";

                }
            }
        }

        // Caps Lock indicator
        CapsLockIndicator {
            id: capsLockIndicator

            showCapsLockIndicator: mainRect.showCapsLockIndicator
            capsLockActive: mainRect.capsLockActive
            animationDuration: mainRect.animationDuration
            elementOpacity: mainRect.elementOpacity
            anchors.right: passwordField.left
            anchors.rightMargin: 15
            anchors.verticalCenter: passwordField.verticalCenter
        }

        // Session selector container
        Item {
            id: sessionSelectContainer

            width: passwordField.width
            height: mainRect.activeSelector === "session" ? (config.intValue("selectorHeight") || 35) : 0
            anchors.horizontalCenter: passwordField.horizontalCenter
            anchors.top: passwordField.bottom
            anchors.topMargin: mainRect.elementSpacing
            clip: true
            opacity: mainRect.elementOpacity

            SessionSelect {
                id: sessionSelect

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: (mainRect.activeSelector === "session" ? 1 : 0) * mainRect.elementOpacity
                visible: opacity > 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: mainRect.animationDuration
                        easing.type: Easing.OutCubic
                    }

                }

            }

            Behavior on height {
                NumberAnimation {
                    duration: mainRect.animationDuration
                    easing.type: Easing.OutCubic
                }

            }

        }

        // Session preview
        SelectorPreview {
            id: sessionPreview

            previewText: sessionSelect.selectedSession
            showPreview: false
            activeSelector: mainRect.activeSelector
            hideWhenSelector: "session"
            fadeInComplete: mainRect.fadeInComplete
            animationDuration: mainRect.animationDuration
            elementOpacity: mainRect.elementOpacity
            anchors.horizontalCenter: passwordField.horizontalCenter
            anchors.top: passwordField.bottom
            anchors.topMargin: config.intValue("selectorPreviewMargin") || 15
            visible: false
            
        }

        // Power buttons selector container
        Item {
            id: powerButtonContainer

            width: passwordField.width
            height: mainRect.activeSelector === "power" ? (config.intValue("selectorHeight") || 35) : 0
            anchors.horizontalCenter: passwordField.horizontalCenter
            anchors.top: passwordField.bottom
            anchors.topMargin: mainRect.elementSpacing
            clip: true
            opacity: mainRect.elementOpacity

            PowerButtons {
                id: powerButtons

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                activeButton: mainRect.activeSelector === "power" ? mainRect.activePowerButton : 0
                fadeInComplete: mainRect.fadeInComplete
                fadeInDuration: mainRect.fadeInDuration
                elementOpacity: mainRect.elementOpacity
                opacity: (mainRect.activeSelector === "power" ? 1 : 0) * mainRect.elementOpacity
                visible: opacity > 0
                onActiveButtonChanged: {
                    if (mainRect.activeSelector === "power")
                        mainRect.activePowerButton = powerButtons.activeButton;

                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: mainRect.animationDuration
                        easing.type: Easing.OutCubic
                    }

                }

            }

            Behavior on height {
                NumberAnimation {
                    duration: mainRect.animationDuration
                    easing.type: Easing.OutCubic
                }

            }

        }

        Behavior on opacity {
            NumberAnimation {
                duration: 800
            }

        }

    }

    // Hide cursor if configured
    Loader {
        active: config.boolValue("showCursor") === false
        anchors.fill: parent

        sourceComponent: MouseArea {
            enabled: true
            cursorShape: Qt.BlankCursor
            acceptedButtons: Qt.NoButton
        }

    }

    Behavior on opacity {
        NumberAnimation {
            duration: 800
        }

    }

}
