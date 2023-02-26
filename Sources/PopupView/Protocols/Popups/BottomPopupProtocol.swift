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
    associatedtype Config = CentrePopupConfig
}
public extension BottomPopup {
    func present() { PopupManager.shared.present(AnyBottomPopup(self)) }
}

// MARK: -Type Eraser
final class AnyBottomPopup: AnyPopup, BottomPopup {}
