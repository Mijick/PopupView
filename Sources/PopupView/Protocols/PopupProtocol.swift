//
//  PopupProtocol.swift of PopupView
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
public protocol Popup: View, Hashable, Equatable {
    associatedtype Config: Configurable
    associatedtype V: View

    func createContent() -> V
}
public extension Popup {
    func present() { PopupManager.present(AnyPopup<Config>(self)) }
    func dismiss() { PopupManager.dismiss(id: id) }

    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    var body: V { createContent() }
    var id: String {
        print(String(describing: Self.self))

        return String(describing: Self.self) }

    func configurePopup(popup: Config) -> Config { popup }
}


// MARK: -Type Eraser
struct AnyPopup<Config: Configurable>: Popup {
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
    func createContent() -> some View { _body }
    func configurePopup(popup: Config) -> Config { _configBuilder(popup) }
}
