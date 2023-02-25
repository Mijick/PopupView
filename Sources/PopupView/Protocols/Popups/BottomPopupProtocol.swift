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
    func present() { PopupStackManager.shared.present(AnyBottomPopup(self)) }
}

// MARK: -Type Eraser
struct AnyBottomPopup: BottomPopup {
    let id: String
    var body: some View { _body }

    private let _configBuilder: (BottomPopupConfig) -> BottomPopupConfig
    private let _body: AnyView

    init(_ popup: some BottomPopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self._configBuilder = popup.configurePopup
    }
}
extension AnyBottomPopup {
    func configurePopup(content: BottomPopupConfig) -> BottomPopupConfig { _configBuilder(content) }
}
