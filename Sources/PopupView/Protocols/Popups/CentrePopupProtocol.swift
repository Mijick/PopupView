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
final class AnyCentrePopup: AnyPopup, CentrePopup {
    private let _configBuilder: (CentrePopupConfig) -> CentrePopupConfig

    init(_ popup: some CentrePopup) {
        self._configBuilder = popup.configurePopup
        super.init(popup)
    }
}
extension AnyCentrePopup {
    func configurePopup(content: CentrePopupConfig) -> CentrePopupConfig { _configBuilder(content) }
}
