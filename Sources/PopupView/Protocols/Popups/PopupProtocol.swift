//
//  PopupProtocol.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol Popup: View, Identifiable, Hashable, Equatable {
    associatedtype Config: Configurable

    var id: String { get }
    func present()
    func configurePopup(content: Config) -> Config
}
public extension Popup {
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    func dismiss() { PopupManager.dismiss(id: id) }
}
