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
    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { self.dragGestureEnabled = value; return self }

    /// Minimal threshold of a drag gesture to close the active popup
    func minimalDragThresholdToClose(_ value: CGFloat) -> Self { self.dragGestureProgressToClose = value; return self }
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
