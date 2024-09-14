//
//  Public+GlobalConfig.swift of MijickPopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Vertical
public extension GlobalConfig.Vertical {

}



// MARK: - Centre
public extension GlobalConfig.Centre {
    
}






public extension GlobalConfig {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Corner radius of the popup at the top of the stack
    func cornerRadius(_ value: CGFloat) -> Self { changing(path: \.cornerRadius, to: value) }

    /// Applies shadows to the popup
    func applyShadow(color: Color = .black.opacity(0.16), radius: CGFloat = 16, x: CGFloat = 0, y: CGFloat = 0) -> Self { changing(path: \.shadow, to: .init(color: color, radius: radius, x: x, y: y)) }

    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { changing(path: \.tapOutsideClosesView, to: value) }

    /// Colour of the overlay covering the view behind the popup. Use .clear to hide the overlay
    func overlayColour(_ value: Color) -> Self { changing(path: \.overlayColour, to: value) }
}
