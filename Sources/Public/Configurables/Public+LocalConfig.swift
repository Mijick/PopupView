//
//  Public+LocalConfig.swift of MijickPopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Content Customisation
public extension LocalConfig.Vertical {
    /// Whether content should ignore safe area
    func ignoresSafeArea(edges: Edge.Set) -> Self { self.ignoredSafeAreaEdges = edges; return self }

    /// Whether the content should take up the entire height of the screen.
    /// Stacked items will be visible.
    func contentFillsWholeHeigh(_ value: Bool) -> Self { self.contentFillsWholeHeight = value; return self }

    /// Whether the content should take up the entire height of the screen.
    /// Stacked items will be invisible
    func contentFillsEntireScreen(_ value: Bool) -> Self { self.contentFillsEntireScreen = value; return self }

    /// Distance between content and keyboard (if present)
    func distanceFromKeyboard(_ value: CGFloat) -> Self { self.distanceFromKeyboard = value; return self }
}

// MARK: - Popup Customisation
public extension LocalConfig.Vertical {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { self.backgroundColour = value; return self }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { self.cornerRadius = value; return self }

    /// Distance of the entire popup (including its background) from the bottom edge
    func topPadding(_ value: CGFloat) -> Self { self.popupPadding.top = value; return self }

    /// Distance of the entire popup (including its background) from the bottom edge
    func bottomPadding(_ value: CGFloat) -> Self { self.popupPadding.bottom = value; return self }

    /// Distance of the entire popup (including its background) from the horizontal edges
    func horizontalPadding(_ value: CGFloat) -> Self { self.popupPadding.horizontal = value; return self }
}

// MARK: - Gestures
public extension LocalConfig.Vertical {
    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { self.tapOutsideClosesView = value; return self }

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { self.dragGestureEnabled = value; return self }

    /// Sets available detents for the popupSets the available detents for the enclosing sheet
    func dragDetents(_ value: [DragDetent]) -> Self { self.dragDetents = value; return self }
}
