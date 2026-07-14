import QtQuick 2.0

Item {
    id: root

    property string displayedText: ""
    // Default waiting sequence
    property var idleSequence: []
    // Currently playing sequence
    property var currentSequence: []
    property int currentMessage: 0
    property bool active: false
    property color textColor: colors.headerText
    // Authentication successful sequence
    property var authSuccessSequence: [{
        "text": "VERIFYING",
        "delay": 900
    }, {
        "text": "CREDENTIALS",
        "delay": 1200
    }, {
        "text": "...",
        "delay": 450
    }, {
        "text": "ACCESS",
        "delay": 800,
        "color": root.textColor
    }, {
        "text": "GRANTED",
        "delay": 1500,
        "color": colors.accessGranted
    }]
    // Authentication failed sequence
    property var authFailedSequence: [{
        "text": "VERIFYING",
        "delay": 900
    }, {
        "text": "CREDENTIALS",
        "delay": 1200
    }, {
        "text": "...",
        "delay": 1000
    }, {
        "text": "AUTHORIZATION",
        "delay": 900,
        "color": root.textColor
    }, {
        "text": "FAILED",
        "delay": 2000,
        "color": colors.accessDenied
    }]

    function showNextMessage() {
        if (!root.active)
            return ;

        if (root.currentMessage >= root.currentSequence.length) {
            if (root.currentSequence === root.idleSequence) {
                // Idle sequence loops forever on the dots
                root.currentMessage = 2;
            } else {
                // Temporary sequence finished
                showWaiting();
                return ;
            }
        }
        root.displayedText = root.currentSequence[root.currentMessage].text;
        if (root.currentSequence[root.currentMessage].color)
            root.textColor = root.currentSequence[root.currentMessage].color;
        else
            root.textColor = colors.headerText;
        messageTimer.interval = root.currentSequence[root.currentMessage].delay;
        root.currentMessage++;
        messageTimer.start();
    }

    function playSequence(sequence) {
        // Plays a sequence of words on the samaritan prompt
        messageTimer.stop();
        currentSequence = sequence;
        currentMessage = 0;
        displayedText = "";
        showNextMessage();
    }

    function showWaiting() {
        //  Idle sequence function
        currentSequence = idleSequence;
        currentMessage = 0;
        displayedText = "";
        showNextMessage();
    }

    function showAuthorizationFailed() { // Authorization failed function
        playSequence(authFailedSequence);
        delay: 1000
    }

    function showAccessGranted() { // Authorization success function
        playSequence(authSuccessSequence); 
    }

    Component.onCompleted: {
        idleSequence = [{  // idle sequence 
            "text": "AWAITING",
            "delay": 900
        }, {
            "text": "CREDENTIALS",
            "delay": 1200
        }, {
            "text": ".",
            "delay": 500
        }, {
            "text": "..",
            "delay": 500
        }, {
            "text": "...",
            "delay": 500
        }, {
            "text": "",
            "delay": 550
        }];
        currentSequence = idleSequence;
    }

    width: 300
    height: 60
    onActiveChanged: {
        if (active)
            showWaiting();
    }

    Text {
        id: promptText

        text: root.displayedText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: promptLine.top
        anchors.bottomMargin: 15
        font.family: colors.samaritanFont
        font.pointSize: 14
        color: root.textColor
    }

    // samaritan prompt line
    Rectangle {
        id: promptLine

        width: 185
        height: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        color: root.textColor
    }

    Canvas { // upside down triangle 
        id: triangle

        width: 20
        height: 18
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: promptLine.bottom
        anchors.topMargin: 6
        rotation: 180
        onPaint: {
            var ctx = getContext("2d");
            ctx.fillStyle = colors.triangleColor;
            ctx.beginPath();
            ctx.moveTo(1, 1);
            ctx.lineTo(width - 1, 1);
            ctx.lineTo(width / 2, height - 1);
            ctx.closePath();
            ctx.fill();
        }

        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite

            NumberAnimation {
                to: 0.2
                duration: 850
            }

            NumberAnimation {
                to: 1
                duration: 850
            }

        }

    }

    Timer { // timer waits the time specified for each message and then goes on to the next one
        id: messageTimer 
    
        repeat: false

        onTriggered: showNextMessage()
    }

}
