//
//  CentrePopupProtocol.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol CentrePopup: Popup {
    func configurePopup(content: CentrePopupConfig) -> CentrePopupConfig
}
public extension CentrePopup {
    func present() { PopupManager.shared.present(AnyCentrePopup(self)) }
}

// MARK: -Type Eraser
struct AnyCentrePopup: CentrePopup {
    let id: String
    var body: some View { _body }

    private let _configBuilder: (CentrePopupConfig) -> CentrePopupConfig
    private let _body: AnyView

    init(_ popup: some CentrePopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self._configBuilder = popup.configurePopup
    }
}
extension AnyCentrePopup {
    func configurePopup(content: CentrePopupConfig) -> CentrePopupConfig { _configBuilder(content) }
}
