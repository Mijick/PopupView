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
public extension ConfigContainer.Common {
    /// Colour of the overlay covering the view behind the popup
    func overlayColour(_ value: Color) -> Self { changing(path: \.overlayColour, to: value) }
}


// MARK: - Internal
public extension ConfigContainer { struct Common: Configurable { public init() {}
    private(set) var overlayColour: Color = .black.opacity(0.44)
}}
