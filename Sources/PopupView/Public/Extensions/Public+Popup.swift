//
//  Public+Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Presenting and Dismissing
public extension Popup {
    /// Displays the popup. Stacks previous one
    func showAndStack() { PopupManager.showAndStack(AnyPopup<Config>(self)) }

    /// Displays the popup. Closes previous one
    func showAndReplace() { PopupManager.showAndReplace(AnyPopup<Config>(self)) }
}
public extension Popup {
    /// Dismisses the last popup on the stack
    func dismiss() { PopupManager.dismiss() }

    /// Dismisses all popups of the selected type on the stack
    func dismiss<P: Popup>(_ popup: P.Type) { PopupManager.dismiss(popup) }

    /// Dismisses all popups on the stack up to the popup with the selected type
    func dismissAll<P: Popup>(upTo popup: P.Type) { PopupManager.dismissAll(upTo: popup) }

    /// Dismisses all popups on the stack
    func dismissAll() { PopupManager.dismissAll() }
}

// MARK: - Available Popups
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
