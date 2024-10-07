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

// MARK: All
public extension GlobalConfig {
    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { self.cornerRadius = value; return self }

    /// Background color of the popup
    func backgroundColor(_ color: Color) -> Self { self.backgroundColor = color; return self }

    /// Applies shadows to the popup
    func shadow(color: Color = .black.opacity(0.16), radius: CGFloat = 16, x: CGFloat = 0, y: CGFloat = 0) -> Self { self.shadow = .init(color: color, radius: radius, x: x, y: y); return self }

    /// Color of the overlay covering the view behind the popup. Use .clear to hide the overlay
    func overlayColor(_ color: Color) -> Self { self.overlayColor = color; return self }

    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismissPopup(_ value: Bool) -> Self { self.isTapOutsideToDismissEnabled = value; return self }
}

// MARK: Centre
public extension GlobalConfig.Centre {
    func popupHorizontalPadding(_ value: CGFloat) -> Self { self.popupPadding = .init(top: 0, leading: value, bottom: 0, trailing: value); return self }
}

// MARK: Vertical
public extension GlobalConfig.Vertical {
    func popupPadding(_ value: EdgeInsets) -> Self { self.popupPadding = value; return self }

    /// Minimal threshold of a drag gesture to close the active popup
    func minimalDragThresholdToDismissPopup(_ value: CGFloat) -> Self { self.dragGestureProgressToClose = value; return self }

    func stackingEnabled(_ value: Bool) -> Self { self.isStackingEnabled = value; return self }

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { self.isDragGestureEnabled = value; return self }

}
