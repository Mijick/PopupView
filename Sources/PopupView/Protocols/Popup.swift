//
//  Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol Popup: View {
    associatedtype Config: Configurable
    associatedtype V: View

    func createContent() -> V
    func configurePopup(popup: Config) -> Config
}

// MARK: - Presenting and Dismissing
public extension Popup {
    /// Displays the popup. Stacks previous one
    func showAndStack() { PopupManager.show(AnyPopup<Config>(self), withStacking: true) }

    /// Displays the popup. Closes previous one
    func showAndReplace() { PopupManager.show(AnyPopup<Config>(self), withStacking: false) }
}
public extension Popup {
    /// Dismisses the last popup on the stack
    func dismiss() { PopupManager.dismiss() }

    /// Dismisses all popups of the selected type on the stack
    func dismiss<P: Popup>(_ popup: P.Type) { PopupManager.dismiss(popup) }

    /// Dismisses all popups on the stack
    func dismissAll() { PopupManager.dismissAll() }
}

// MARK: - Others
public extension Popup {
    var id: String { .init(describing: Self.self) }
    var body: V { createContent() }

    func configurePopup(popup: Config) -> Config { popup }
}
