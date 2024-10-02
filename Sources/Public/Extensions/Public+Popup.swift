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
    @discardableResult func dismissAfter(_ seconds: Double) -> some Popup { eraseObject { $0.dismissTimer = DispatchSource.createAction(deadline: seconds) { PopupManager.performOperation(.remove(self.id)) } }}

    /// Supplies an observable object to a view’s hierarchy
    @discardableResult func setEnvironmentObject<T: ObservableObject>(_ object: T) -> some Popup { eraseObject(environmentObject: object) { _ in }}

    /// Action to be executed after popups is dismissed
    @discardableResult func onDismiss(_ action: @escaping () -> ()) -> some Popup { eraseObject { $0.onDismiss = action }}
}

// MARK: - Available Popups
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
