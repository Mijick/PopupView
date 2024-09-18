//
//  Public+GlobalConfig.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Vertical
public extension GlobalConfig.Vertical {
    /// Distance between content and keyboard (if present)
    func distanceFromKeyboard(_ value: CGFloat) -> Self { self.distanceFromKeyboard = value; return self }

    /// Scale factor of subsequent popups on the stack.
    /// For example, for **value** = 0.1, the next popup on the stack will have a size of 0.9 of the active popup, and the one after next 0.8.
    func stackScale(_ value: CGFloat) -> Self { self.stackScaleFactor = value; return self }

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { self.dragGestureEnabled = value; return self }

    /// Minimal threshold of a drag gesture to close the active popup
    func minimalDragThresholdToClose(_ value: CGFloat) -> Self { self.dragGestureProgressToClose = value; return self }
}



// MARK: - Centre
public extension GlobalConfig.Centre {
    /// Scale of the initial state of the popup animation while opening
    func transitionEntryScale(_ value: CGFloat) -> Self { self.transitionEntryScale = value; return self }

    /// Scale of the final state of the popup animation while closing
    func transitionExitScale(_ value: CGFloat) -> Self { self.transitionExitScale = value; return self }
}






public extension GlobalConfig {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { self.backgroundColour = value; return self }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { self.cornerRadius = value; return self }

    /// Applies shadows to the popup
    func applyShadow(color: Color = .black.opacity(0.16), radius: CGFloat = 16, x: CGFloat = 0, y: CGFloat = 0) -> Self { self.shadow = .init(color: color, radius: radius, x: x, y: y); return self }

    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { self.tapOutsideClosesView = value; return self }

    /// Colour of the overlay covering the view behind the popup. Use .clear to hide the overlay
    func overlayColour(_ value: Color) -> Self { self.overlayColour = value; return self }
}
