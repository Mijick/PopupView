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
    func showAndStack() { PopupManager.showAndStack(self) }

    /// Displays the popup. Closes previous one
    func showAndReplace() { PopupManager.showAndReplace(self) }
}

// MARK: - Modifiers
public extension Popup {
    /// Closes popup after n seconds
    @discardableResult func dismissAfter(_ seconds: Double) -> some Popup { PopupManager.dismissPopupAfter(self, seconds); return self }

    /// Hides the overlay for the selected popup
    @discardableResult func hideOverlay() -> some Popup { PopupManager.setTempValue(isOverlayHidden: true); return self }

    /// Supplies an observable object to a view’s hierarchy
    @discardableResult func setEnvironmentObject<T: ObservableObject>(_ object: T) -> some Popup { PopupManager.setTempValue(environmentObject: object); return self }

    /// Action to be executed after popups is dismissed
    @discardableResult func onDismiss(_ action: @escaping () -> ()) -> some Popup { PopupManager.setTempValue(onDismiss: action); return self }
}

// MARK: - Available Popups
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
