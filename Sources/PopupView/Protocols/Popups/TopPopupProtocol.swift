//
//  TopPopupProtocol.swift of PopupView
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
public extension TopPopup {
    func present() { PopupManager.shared.present(AnyTopPopup(self)) }
}

// MARK: -Type Eraser
final class AnyTopPopup: AnyPopup, TopPopup {}




class AnyPopup {
    let id: String
    var body: some View { _body }

    private let _body: AnyView
    private let _configBuilder: (Configurable) -> Configurable


    init(_ popup: some Popup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self._configBuilder = popup.configurePopup as! (any Configurable) -> any Configurable
    }
}
extension AnyPopup {
    func configurePopup<C: Configurable>(content: C) -> C { _configBuilder(content) as! C }
}
