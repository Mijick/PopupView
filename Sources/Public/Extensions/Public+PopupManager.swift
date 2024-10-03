//
//  Public+PopupManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Presenting and Dismissing
public extension PopupManager {
    /// Displays the popup. Stacks previous one
    static func showAndStack(_ popup: some Popup) { shared.performOperation(.insertAndStack(.init(popup))) }

    /// Displays the popup. Closes previous one
    static func showAndReplace(_ popup: some Popup) { shared.performOperation(.insertAndReplace(.init(popup))) }
}
public extension PopupManager {
    /// Dismisses the last popup on the stack
    static func dismiss() { shared.performOperation(.removeLast) }

    /// Dismisses all the popups of provided ID on the stack
    static func dismissPopup(id: String) { shared.performOperation(.remove(.init(value: id))) }

    /// Dismisses all the popups of provided type on the stack
    static func dismissPopup<P: Popup>(_ popup: P.Type) { shared.performOperation(.remove(ID(popup))) }

    /// Dismisses all the popups on the stack up to the popup with the selected type
    static func dismissAll<P: Popup>(upTo popup: P.Type) { shared.performOperation(.removeAllUpTo(ID(popup))) }

    /// Dismisses all the popups on the stack
    static func dismissAll() { shared.performOperation(.removeAll) }
}
