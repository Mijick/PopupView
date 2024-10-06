//
//  Public+PopupManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Dismissing
public extension PopupManager {
    /// Dismisses the last popup on the stack
    static func dismiss(manID: PopupManagerID = .shared) { fetchInstance(for: manID)?.stack(.removeLastPopup) }

    /// Dismisses all the popups of provided ID on the stack
    static func dismissPopup(id: String, manID: PopupManagerID = .shared) { fetchInstance(for: manID)?.stack(.removeAllPopupsWithID(id)) }

    /// Dismisses all the popups of provided type on the stack
    static func dismissPopup<P: Popup>(_ popup: P.Type, manID: PopupManagerID = .shared) { fetchInstance(for: manID)?.stack(.removeAllPopupsOfType(popup)) }

    /// Dismisses all the popups on the stack
    static func dismissAll(manID: PopupManagerID = .shared) { fetchInstance(for: manID)?.stack(.removeAllPopups) }
}
