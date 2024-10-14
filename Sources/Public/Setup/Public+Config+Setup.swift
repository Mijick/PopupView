//
//  Public+Config+Setup.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

// MARK: All
public extension GlobalConfig {
    /// Distance of the entire popup (including its background) from the horizontal edges
    func popupHorizontalPadding(_ value: CGFloat) -> Self { self.popupPadding = .init(top: popupPadding.top, leading: value, bottom: popupPadding.bottom, trailing: value); return self }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { self.cornerRadius = value; return self }

    /// Background color of the popup
    func backgroundColor(_ color: Color) -> Self { self.backgroundColor = color; return self }

    /// Color of the overlay covering the view behind the popup. Use .clear to hide the overlay
    func overlayColor(_ color: Color) -> Self { self.overlayColor = color; return self }

    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismissPopup(_ value: Bool) -> Self { self.isTapOutsideToDismissEnabled = value; return self }
}

// MARK: Vertical
public extension GlobalConfig.Vertical {
    /// Distance of the entire popup (including its background) from the top edge
    func popupTopPadding(_ value: CGFloat) -> Self { self.popupPadding = .init(top: value, leading: popupPadding.leading, bottom: popupPadding.bottom, trailing: popupPadding.trailing); return self }

    /// Distance of the entire popup (including its background) from the bottom edge
    func popupBottomPadding(_ value: CGFloat) -> Self { self.popupPadding = .init(top: popupPadding.top, leading: popupPadding.leading, bottom: value, trailing: popupPadding.trailing); return self }

    /// Minimal threshold of a drag gesture to close the active popup
    func minimalDragThresholdToDismissPopup(_ value: CGFloat) -> Self { self.dragGestureProgressToClose = value; return self }

    func enableStacking(_ value: Bool) -> Self { self.isStackingEnabled = value; return self }

    /// Popup can be closed with drag gesture if enabled
    func enableDragGesture(_ value: Bool) -> Self { self.isDragGestureEnabled = value; return self }
}
