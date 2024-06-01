//
//  LocalConfig.CentrePopup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Popup Customisation
public extension CentrePopupConfig {
    /// Background colour of the popup
    func backgroundColour(_ value: Color) -> Self { changing(path: \.backgroundColour, to: value) }

    /// Corner radius of the popup
    func cornerRadius(_ value: CGFloat) -> Self { changing(path: \.cornerRadius, to: value) }
    
    /// Distance of the entire popup (including its background) from the horizontal edges
    func horizontalPadding(_ value: CGFloat) -> Self { changing(path: \.horizontalPadding, to: value) }
}

// MARK: - Gestures
public extension CentrePopupConfig {
    /// Dismisses the active popup when tapped outside its area if enabled
    func tapOutsideToDismiss(_ value: Bool) -> Self { changing(path: \.tapOutsideClosesView, to: value) }
}

// MARK: - Others
public extension CentrePopupConfig {
    /// Sets the priority of the popup on the stack
    func setPriority(_ value: Priority) -> Self { changing(path: \.priority, to: value) }
}


// MARK: - Internal
public struct CentrePopupConfig: Configurable { public init() {}
    private(set) var backgroundColour: Color? = nil
    private(set) var cornerRadius: CGFloat? = nil
    private(set) var horizontalPadding: CGFloat = 12

    private(set) var tapOutsideClosesView: Bool? = nil

    private(set) var priority: Priority = .normal
}
