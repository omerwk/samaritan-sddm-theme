.pragma library

/**
 * Configuration manager utilities
 */

/**
 * Get element opacity with validation
 */
function getElementOpacity(config) {
    var opacity = config.stringValue("elementOpacity")
    if (opacity === "") return 1.0
    var num = parseFloat(opacity)
    return (num >= 0.0 && num <= 1.0) ? num : 1.0
}

