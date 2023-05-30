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
    /// HINT: It is recommended to enable when a scroll view is present in the content view
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
    func activePopupCornerRadius(_ value: CGFloat) -> Self { changing(path: \.activePopupCornerRadius, to: value) }

    /// Distance of the entire popup (including its background) from the bottom edge
    func bottomPadding(_ value: CGFloat) -> Self { changing(path: \.popupPadding.bottom, to: value) }

    /// Distance of the entire popup (including its background) from the horizontal edges
    func horizontalPadding(_ value: CGFloat) -> Self { changing(path: \.popupPadding.horizontal, to: value) }
}

// MARK: - Stack Customisation
public extension BottomPopupConfig {
    /// Corner radius for popups on the stack
    func stackCornerRadius(_ value: CGFloat) -> Self { changing(path: \.stackCornerRadius, to: value) }

    /// Distance between popups on the stack
    func stackOffset(_ value: CGFloat) -> Self { changing(path: \.stackOffset, to: value) }

    /// Scale factor of subsequent popups on the stack.
    /// For example, for **value** = 0.1, the next popup on the stack will have a size of 0.9 of the active popup, and the one after next 0.8.
    func stackScale(_ value: CGFloat) -> Self { changing(path: \.stackScaleFactor, to: value) }

    /// Maximum number of popups on the stack
    func stackLimit(_ value: Int) -> Self { changing(path: \.stackLimit, to: value) }
}

// MARK: - Gestures
public extension BottomPopupConfig {
    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { changing(path: \.tapOutsideClosesView, to: value) }

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { changing(path: \.dragGestureEnabled, to: value) }

    /// Minimal threshold of a drag gesture to close the active popup
    func minimalDragThresholdToClose(_ value: CGFloat) -> Self { changing(path: \.dragGestureProgressToClose, to: value) }
}

// MARK: - Animations
public extension BottomPopupConfig {
    /// Default closing and opening animations for popups
    func transitionAnimation(_ value: Animation) -> Self { changing(path: \.transitionAnimation, to: value) }

    /// Default animation for closing popup with drag gesture
    func dragGestureAnimation(_ value: Animation) -> Self { changing(path: \.dragGestureAnimation, to: value) }
}


// MARK: - Internal
public struct BottomPopupConfig: Configurable {
    private(set) var contentIgnoresSafeArea: Bool = false
    private(set) var contentFillsWholeHeight: Bool = false
    private(set) var contentFillsEntireScreen: Bool = false
    private(set) var distanceFromKeyboard: CGFloat = 8

    private(set) var backgroundColour: Color = .white
    private(set) var activePopupCornerRadius: CGFloat = 32
    private(set) var popupPadding: (bottom: CGFloat, horizontal: CGFloat) = (0, 0)

    private(set) var stackCornerRadius: CGFloat = 32 * 0.6
    private(set) var stackOffset: CGFloat = 8
    private(set) var stackScaleFactor: CGFloat = 0.1
    private(set) var stackLimit: Int = 4

    private(set) var tapOutsideClosesView: Bool = false
    private(set) var dragGestureEnabled: Bool = true
    private(set) var dragGestureProgressToClose: CGFloat = 1/3

    private(set) var dragGestureAnimation: Animation = .interactiveSpring()
    private(set) var transitionAnimation: Animation = .spring(response: 0.44, dampingFraction: 1, blendDuration: 0.4)
}
