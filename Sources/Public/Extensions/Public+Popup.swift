//
//  Public+Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Presenting
public extension Popup {
    /// Displays the popup. Stacks previous one
    @discardableResult func showAndStack() -> some Popup { PopupManager.showAndStack(AnyPopup<Config>(self)); return self }

    /// Displays the popup. Closes previous one
    @discardableResult func showAndReplace() -> some Popup { PopupManager.showAndReplace(AnyPopup<Config>(self)); return self }

    /// Closes popup after n seconds
    func dismissAfter(_ seconds: Double) { DispatchQueue.main.asyncAfter(deadline: .now() + max(0.5, seconds)) {
        PopupManager.dismiss(Self.self)
    }}
}

// MARK: - Available Popups
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
