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
    static func showAndStack(_ popup: some Popup) { performOperation(.insertAndStack(popup)) }

    /// Displays the popup. Closes previous one
    static func showAndReplace(_ popup: some Popup) { performOperation(.insertAndReplace(popup)) }
}
public extension PopupManager {
    /// Dismisses last popup on the stack
    static func dismissLast() { performOperation(.removeLast) }
    
    /// Dismisses all popups of provided popupId on the stack.
    static func dismiss(popupId: String) { performOperation(.remove(id: popupId)) }

    /// Dismisses all popups of provided type on the stack.
    static func dismiss<P: Popup>(_ popup: P.Type) { performOperation(.remove(id: .init(describing: popup))) }

    /// Dismisses all popups on the stack up to the popup with the selected id
    static func dismissAll(popupId: String) { performOperation(.removeAllUpTo(id: popupId)) }

    /// Dismisses all popups on the stack up to the popup with the selected type
    static func dismissAll<P: Popup>(upTo popup: P.Type) { performOperation(.removeAllUpTo(id: .init(describing: popup))) }
    
    /// Dismisses all the popups on the stack.
    static func dismissAll() { performOperation(.removeAll) }
}
