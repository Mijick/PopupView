//
//  Public+Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol Popup: View {
    associatedtype Config: LocalConfig

    func configurePopup(popup: Config) -> Config
    func onFocus()
    func onDismiss()
}



// MARK: - Presenting
public extension Popup {
    /// Displays the popup. Stacks previous one
    func present(id: PopupManagerID = .shared) { PopupManager.getInstance(id)?.performOperation(.insert(self)) }
}

// MARK: - Modifiers
public extension Popup {
    /// Closes popup after n seconds
    func dismissAfter(_ seconds: Double) -> some Popup { eraseObject { $0.dismissTimer = .init(secondsToDismiss: seconds) }}

    func setCustomID(_ id: String) -> some Popup { eraseObject { $0.id = .create(from: id) } }

    /// Supplies an observable object to a view’s hierarchy
    func setEnvironmentObject<T: ObservableObject>(_ object: T) -> some Popup { eraseObject { $0._body = AnyView(environmentObject(object)) }}
}

// MARK: - Available Popups
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
