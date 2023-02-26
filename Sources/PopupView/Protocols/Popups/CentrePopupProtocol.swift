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
final class AnyCentrePopup: AnyPopup<CentrePopupConfig>, CentrePopup {
    typealias Config = CentrePopupConfig


}
