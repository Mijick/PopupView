//
//  BottomPopupProtocol.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol BottomPopup: Popup {
    func configurePopup(content: BottomPopupConfig) -> BottomPopupConfig
}
public extension BottomPopup {
    func present() { PopupManager.shared.present(AnyBottomPopup(self)) }
}

// MARK: -Type Eraser
final class AnyBottomPopup: AnyPopup, BottomPopup {
    private let _configBuilder: (BottomPopupConfig) -> BottomPopupConfig

    init(_ popup: some BottomPopup) {
        self._configBuilder = popup.configurePopup
        super.init(popup)
    }
}
extension AnyBottomPopup {
    func configurePopup(content: BottomPopupConfig) -> BottomPopupConfig { _configBuilder(content) }
}
