.pragma library

/**
 * Navigation handler utilities for SDDM theme
 */

/**
 * Navigate selector in given direction
 */
function navigateSelector(selector, direction, userSelect, sessionSelect) {
    var count = selector === "user" ? userSelect.userCount : sessionSelect.sessionCount
    if (count === 0) return false
    
    var currentIndex = selector === "user" ? userSelect.selectedIndex : sessionSelect.selectedIndex
    
    if (direction === "left") {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : count - 1
    } else {
        currentIndex = currentIndex < count - 1 ? currentIndex + 1 : 0
    }
    
    if (selector === "user") {
        userSelect.selectedIndex = currentIndex
    } else {
        sessionSelect.selectedIndex = currentIndex
    }
    return true
}

/**
 * Handle power button navigation
 */
function navigatePowerButton(direction, powerButtons, activePowerButton) {
    if (!powerButtons) return false
    
    if (direction === "left") {
        powerButtons.activeButton = powerButtons.activeButton > 0 ? powerButtons.activeButton - 1 : 2
    } else {
        powerButtons.activeButton = powerButtons.activeButton < 2 ? powerButtons.activeButton + 1 : 0
    }
    return powerButtons.activeButton
}

