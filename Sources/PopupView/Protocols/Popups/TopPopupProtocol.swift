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
    func configurePopup(content: TopPopupConfig) -> TopPopupConfig
}
public extension TopPopup {
    func present() { PopupManager.shared.present(AnyTopPopup(self)) }
}

// MARK: -Type Eraser
struct AnyTopPopup: TopPopup {
    let id: String
    var body: some View { _body }

    private let _configBuilder: (TopPopupConfig) -> TopPopupConfig
    private let _body: AnyView

    init(_ popup: some TopPopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self._configBuilder = popup.configurePopup
    }
}
extension AnyTopPopup {
    func configurePopup(content: TopPopupConfig) -> TopPopupConfig { _configBuilder(content) }
}
