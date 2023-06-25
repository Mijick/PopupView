//
//  Centre.GlobalConfig.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Popup Customisation
public extension GlobalConfig.Centre {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { changing(path: \.cornerRadius, to: value) }
}

// MARK: - Animations
public extension GlobalConfig.Centre {
    /// Time to animate content while presenting new popup
    func contentAnimationTime(_ value: CGFloat) -> Self { changing(path: \.contentAnimationTime, to: value) }

    /// Scale of the initial state of the popup animation while opening
    func transitionEntryScale(_ value: CGFloat) -> Self { changing(path: \.transitionEntryScale, to: value) }

    /// Scale of the final state of the popup animation while closing
    func transitionExitScale(_ value: CGFloat) -> Self { changing(path: \.transitionExitScale, to: value) }

    /// Default closing and opening animations for popups
    func transitionAnimation(_ value: Animation) -> Self { changing(path: \.transitionAnimation, to: value) }
}


// MARK: - Internal
public extension GlobalConfig { struct Centre: Configurable {
    private(set) var backgroundColour: Color = .white
    private(set) var cornerRadius: CGFloat = 24

    private(set) var contentAnimationTime: CGFloat = 0.1
    private(set) var transitionEntryScale: CGFloat = 1.1
    private(set) var transitionExitScale: CGFloat = 0.86
    private(set) var transitionAnimation: Animation = .spring(response: 0.28, dampingFraction: 1, blendDuration: 0.28)
}}
