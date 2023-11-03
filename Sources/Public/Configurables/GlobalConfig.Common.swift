//
//  GlobalConfig.Common.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Overlay
public extension GlobalConfig.Common {
    /// Colour of the overlay covering the view behind the popup
    func overlayColour(_ value: Color) -> Self { changing(path: \.overlayColour, to: value) }
}

// MARK: - Animations
public extension GlobalConfig.Common {
    /// Animation for closing and opening popups
    func animation(_ value: AnimationType) -> Self { changing(path: \.animation, to: value) }
}


// MARK: - Internal
public extension GlobalConfig { struct Common: Configurable { public init() {}
    private(set) var overlayColour: Color = .black.opacity(0.44)
    private(set) var animation: AnimationType = .spring
}}
