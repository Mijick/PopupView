//
//  Public+LocalConfig.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Vertical

// MARK: Content Customisation
public extension LocalConfig.Vertical {
    /// Whether content should ignore safe area
    func ignoresSafeArea(edges: Edge.Set) -> Self { self.ignoredSafeAreaEdges = edges; return self }

    func changeHeightMode(_ value: HeightMode) -> Self { self.heightMode = value; return self }
}

// MARK: Popup Customisation
public extension LocalConfig.Vertical {

    /// Distance of the entire popup (including its background) from the bottom edge
    func topPadding(_ value: CGFloat) -> Self { self.popupPadding.top = value; return self }

    /// Distance of the entire popup (including its background) from the bottom edge
    func bottomPadding(_ value: CGFloat) -> Self { self.popupPadding.bottom = value; return self }

    /// Distance of the entire popup (including its background) from the horizontal edges
    func horizontalPadding(_ value: CGFloat) -> Self { self.popupPadding.leading = value; self.popupPadding.trailing = value; return self }
}

// MARK: Gestures
public extension LocalConfig.Vertical {

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { self.dragGestureEnabled = value; return self }

    /// Sets available detents for the popupSets the available detents for the enclosing sheet
    func dragDetents(_ value: [DragDetent]) -> Self { self.dragDetents = value; return self }
}


// MARK: - Centre

// MARK: Popup Customisation
public extension CentrePopupConfig {

    /// Distance of the entire popup (including its background) from the horizontal edges
    func horizontalPadding(_ value: CGFloat) -> Self { self.popupPadding = .init(top: 0, leading: value, bottom: 0, trailing: value); return self }
}






public extension LocalConfig {

    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { self.backgroundColour = value; return self }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { self.cornerRadius = value; return self }

    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { self.isTapOutsideToDismissEnabled = value; return self }

    /// sss
    func overlayColour(_ value: Color) -> Self { self.overlayColour = value; return self }
}
