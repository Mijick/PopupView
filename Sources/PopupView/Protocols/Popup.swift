//
//  Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol TopPopup: Popup {
    associatedtype Config = TopPopupConfig
}
public protocol CentrePopup: Popup {
    associatedtype Config = CentrePopupConfig
}
public protocol BottomPopup: Popup {
    associatedtype Config = BottomPopupConfig
}


// MARK: -Implementation
public protocol Popup: View {
    associatedtype Config: Configurable
    associatedtype V: View

    var id: String { get }

    func createContent() -> V
    func configurePopup(popup: Config) -> Config
}
public extension Popup {
    func present() { PopupManager.present(AnyPopup<Config>(self)) }
    func dismiss() { PopupManager.dismiss(id: id) }

    var id: String { .init(describing: Self.self) }

    func configurePopup(popup: Config) -> Config { popup }
}
extension Popup {
    var body: V { createContent() }
}


// MARK: -Type Eraser
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
