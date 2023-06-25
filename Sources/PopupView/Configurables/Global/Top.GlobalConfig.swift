//
//  Top.GlobalConfig.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Popup Customisation
public extension GlobalConfig.Top {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { changing(path: \.cornerRadius, to: value) }
}

// MARK: - Stack Customisation
public extension GlobalConfig.Top {
    /// Corner radius multiplier for popups on the stack.
    /// For example **value** = 0.5 means that the stacked popups will be have a corner radius equal to activeCornerRadius * 0.5.
    func stackCornerRadiusMultiplier(_ value: CGFloat) -> Self { changing(path: \.stackCornerRadiusMultiplier, to: value) }

    /// Distance between popups on the stack
    func stackOffset(_ value: CGFloat) -> Self { changing(path: \.stackOffset, to: value) }

    /// Scale factor of subsequent popups on the stack.
    /// For example, for **value** = 0.1, the next popup on the stack will have a size of 0.9 of the active popup, and the one after next 0.8.
    func stackScale(_ value: CGFloat) -> Self { changing(path: \.stackScaleFactor, to: value) }

    /// Maximum number of popups on the stack
    func stackLimit(_ value: Int) -> Self { changing(path: \.stackLimit, to: value) }
}

// MARK: - Gestures
public extension GlobalConfig.Top {
    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { changing(path: \.tapOutsideClosesView, to: value) }

    /// Popup can be closed with drag gesture if enabled
    func dragGestureEnabled(_ value: Bool) -> Self { changing(path: \.dragGestureEnabled, to: value) }

    /// Minimal threshold of a drag gesture to close the active popup
    func minimalDragThresholdToClose(_ value: CGFloat) -> Self { changing(path: \.dragGestureProgressToClose, to: value) }
}

// MARK: - Animations
public extension GlobalConfig.Top {
    /// Default closing and opening animations for popups
    func transitionAnimation(_ value: Animation) -> Self { changing(path: \.transitionAnimation, to: value) }

    /// Default animation for closing popup with drag gesture
    func dragGestureAnimation(_ value: Animation) -> Self { changing(path: \.dragGestureAnimation, to: value) }
}


// MARK: - Internal
public extension GlobalConfig { struct Top: Configurable {
    private(set) var backgroundColour: Color = .white
    private(set) var cornerRadius: CGFloat = 24

    private(set) var stackCornerRadiusMultiplier: CGFloat = 0.6
    private(set) var stackOffset: CGFloat = 6
    private(set) var stackScaleFactor: CGFloat = 0.06
    private(set) var stackLimit: Int = 3

    private(set) var tapOutsideClosesView: Bool = false
    private(set) var dragGestureEnabled: Bool = true
    private(set) var dragGestureProgressToClose: CGFloat = 1/3

    private(set) var transitionAnimation: Animation = .spring(response: 0.32, dampingFraction: 1, blendDuration: 0.32)
    private(set) var dragGestureAnimation: Animation = .interactiveSpring()
}}
