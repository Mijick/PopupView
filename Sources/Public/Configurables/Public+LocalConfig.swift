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

// MARK: All
public extension LocalConfig {
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
public extension LocalConfig.Vertical {
    /// Distance of the entire popup (including its background) from the top edge
    func popupTopPadding(_ value: CGFloat) -> Self { self.popupPadding = .init(top: value, leading: popupPadding.leading, bottom: popupPadding.bottom, trailing: popupPadding.trailing); return self }

    /// Distance of the entire popup (including its background) from the bottom edge
    func popupBottomPadding(_ value: CGFloat) -> Self { self.popupPadding = .init(top: popupPadding.top, leading: popupPadding.leading, bottom: value, trailing: popupPadding.trailing); return self }





    /// Whether content should ignore safe area
    func ignoresSafeArea(edges: Edge.Set) -> Self { self.ignoredSafeAreaEdges = edges; return self }

    func changeHeightMode(_ value: HeightMode) -> Self { self.heightMode = value; return self }



    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { self.isDragGestureEnabled = value; return self }

    /// Sets available detents for the popupSets the available detents for the enclosing sheet
    func dragDetents(_ value: [DragDetent]) -> Self { self.dragDetents = value; return self }
}
