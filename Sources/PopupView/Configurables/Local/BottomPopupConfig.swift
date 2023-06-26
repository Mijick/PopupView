//
//  BottomPopupConfig.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Content Customisation
public extension BottomPopupConfig {
    /// Whether content should ignore safe area
    func contentIgnoresSafeArea(_ value: Bool) -> Self { changing(path: \.contentIgnoresSafeArea, to: value) }

    /// Whether the content should take up the entire height of the screen.
    /// Stacked items will be visible.
    func contentFillsWholeHeigh(_ value: Bool) -> Self { changing(path: \.contentFillsWholeHeight, to: value) }

    /// Whether the content should take up the entire height of the screen.
    /// Stacked items will be invisible
    func contentFillsEntireScreen(_ value: Bool) -> Self { changing(path: \.contentFillsEntireScreen, to: value) }

    /// Distance between content and keyboard (if present)
    func distanceFromKeyboard(_ value: CGFloat) -> Self { changing(path: \.distanceFromKeyboard, to: value) }
}

// MARK: - Popup Customisation
public extension BottomPopupConfig {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { changing(path: \.cornerRadius, to: value) }

    /// Distance of the entire popup (including its background) from the bottom edge
    func bottomPadding(_ value: CGFloat) -> Self { changing(path: \.popupPadding.bottom, to: value) }

    /// Distance of the entire popup (including its background) from the horizontal edges
    func horizontalPadding(_ value: CGFloat) -> Self { changing(path: \.popupPadding.horizontal, to: value) }
}

// MARK: - Gestures
public extension BottomPopupConfig {
    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { changing(path: \.tapOutsideClosesView, to: value) }

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { changing(path: \.dragGestureEnabled, to: value) }
}

// MARK: - Actions
public extension BottomPopupConfig {
    /// Triggers every time the popup is at the top of the stack
    func onFocus(_ action: @escaping () -> ()) -> Self { changing(path: \.onFocus, to: action) }
}


// MARK: - Internal
public struct BottomPopupConfig: Configurable {
    private(set) var contentIgnoresSafeArea: Bool = false
    private(set) var contentFillsWholeHeight: Bool = false
    private(set) var contentFillsEntireScreen: Bool = false
    private(set) var distanceFromKeyboard: CGFloat? = nil

    private(set) var backgroundColour: Color? = nil
    private(set) var cornerRadius: CGFloat? = nil
    private(set) var popupPadding: (bottom: CGFloat, horizontal: CGFloat) = (0, 0)

    private(set) var tapOutsideClosesView: Bool? = nil
    private(set) var dragGestureEnabled: Bool? = nil

    private(set) var onFocus: () -> () = {}
}
