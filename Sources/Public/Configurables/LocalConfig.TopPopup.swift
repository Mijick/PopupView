//
//  LocalConfig.TopPopup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Content Customisation
public extension TopPopupConfig {
    /// Whether content should ignore safe area
    func contentIgnoresSafeArea(_ value: Bool) -> Self { changing(path: \.contentIgnoresSafeArea, to: value) }
}

// MARK: - Popup Customisation
public extension TopPopupConfig {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { changing(path: \.cornerRadius, to: value) }

    /// Distance of the entire popup (including its background) from the top edge
    func topPadding(_ value: CGFloat) -> Self { changing(path: \.popupPadding.top, to: value) }

    /// Distance of the entire popup (including its background) from the horizontal edges
    func horizontalPadding(_ value: CGFloat) -> Self { changing(path: \.popupPadding.horizontal, to: value) }
}

// MARK: - Gestures
public extension TopPopupConfig {
    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { changing(path: \.tapOutsideClosesView, to: value) }

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { changing(path: \.dragGestureEnabled, to: value) }
}

// MARK: - Others
public extension TopPopupConfig {
    /// Sets the priority of the popup on the stack
    func setPriority(_ value: Priority) -> Self { changing(path: \.priority, to: value) }
}


// MARK: - Internal
public struct TopPopupConfig: Configurable { public init() {}
    private(set) var contentIgnoresSafeArea: Bool = false

    private(set) var backgroundColour: Color? = nil
    private(set) var cornerRadius: CGFloat? = nil
    private(set) var popupPadding: (top: CGFloat, horizontal: CGFloat) = (0, 0)

    private(set) var tapOutsideClosesView: Bool? = nil
    private(set) var dragGestureEnabled: Bool? = nil

    private(set) var priority: Priority = .normal
}
