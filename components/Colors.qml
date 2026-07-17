import QtQuick 2.0

QtObject {
    property color background: config.stringValue("background") || "#000000"

    // Main text
    property color primaryText: config.stringValue("primaryText") || "#F8F8FF"
    property color secondaryText: config.stringValue("secondaryText") || "#D6D6D6"
    property color mutedText: config.stringValue("mutedText") || "#9A9A9A"
    property color headerText: config.stringValue("headerText") || "#C8C8C8"
    property color triangleColor: config.stringValue("triangleColor") || "#d92b2b"

    // System messages
    property color bootText: config.stringValue("bootText") || "#AFAFAF"
    property color onlineText: config.stringValue("onlineText") || "#FFFFFF"

    // Authorization
    property color accessGranted: config.stringValue("accessGranted") || "#00FF00"
    property color accessDenied: config.stringValue("accessDenied") || "#FF0000"

    // Font family
    property string mainFont: config.stringValue("mainFont") || "monoMMM_5"
    property string headerFont: config.stringValue("headerFont") || "MagdaCleanMono"
    property string samaritanFont: config.stringValue("samaritanFont") || "MagdaCleanMono"
    
}