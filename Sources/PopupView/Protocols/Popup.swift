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

    var id: String { get }

    func createContent() -> V
    func configurePopup(popup: Config) -> Config
}

// MARK: - Presenting Popups
public extension Popup {

    /// Displays the popup. Stacks previous one
    func showAndStack() { PopupManager.show(AnyPopup<Config>(self), withStacking: true) }

    /// Displays the popup. Closes previous one
    func showAndReplace() { PopupManager.show(AnyPopup<Config>(self), withStacking: false) }
}

// MARK: - Dismissing Popups
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
    func configurePopup(popup: Config) -> Config { popup }

    var id: String { .init(describing: Self.self) }
    var body: V { createContent() }
}

// MARK: - Deprecated
public extension Popup {
    @available(*, deprecated, message: "Method no longer supported. Use showAndStack or showAndReplace instead")
    func present() { PopupManager.show(AnyPopup<Config>(self), withStacking: true) }
}


public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public protocol CentrePopup: Popup { associatedtype Config = CentrePopupConfig }
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }

struct AnyPopup<Config: Configurable>: Popup, Hashable {
    let id: String

    private let _body: AnyView
    private let _configBuilder: (Config) -> Config

    init(_ popup: some Popup) {
        self.id = popup.id
        self._body = AnyView(popup)
        self._configBuilder = popup.configurePopup as! (Config) -> Config
    }
}
extension AnyPopup {
    static func == (lhs: AnyPopup<Config>, rhs: AnyPopup<Config>) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
extension AnyPopup {
    func createContent() -> some View { _body }
    func configurePopup(popup: Config) -> Config { _configBuilder(popup) }
}
