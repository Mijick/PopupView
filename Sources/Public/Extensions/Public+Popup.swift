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
    func showAndStack(id: PopupManagerInstance = .shared) { PopupManager.getInstance(id).performOperation(.insertAndStack(.init(self, id: id))) }

    /// Displays the popup. Closes previous one
    func showAndReplace(id: PopupManagerInstance = .shared) { PopupManager.getInstance(id).performOperation(.insertAndReplace(.init(self, id: id))) }
}

// MARK: - Modifiers
public extension Popup {
    /// Closes popup after n seconds
    func dismissAfter(_ seconds: Double) -> some Popup { eraseObject { $0.dismissTimer = .init(time: seconds) }}

    /// Supplies an observable object to a view’s hierarchy
    func setEnvironmentObject<T: ObservableObject>(_ object: T) -> some Popup { eraseObject { $0._body = AnyView(environmentObject(object)) }}

    /// Action to be executed after popups is dismissed
    func onDismiss(_ action: @escaping () -> ()) -> some Popup { eraseObject { $0.onDismiss = action }}
}

// MARK: - Available Popups
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
