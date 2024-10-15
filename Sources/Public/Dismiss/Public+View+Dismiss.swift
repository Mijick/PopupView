//
//  Public+View+Dismiss.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public extension View {
    /**
     Dismisses the currently active popup.
     Makes the next popup in the stack the new active popup.
     */
    func dismissLastPopup(popupManagerID: PopupManagerID = .shared) { PopupManager.dismissLastPopup(popupManagerID: popupManagerID) }

    /// Dismisses all the popups of provided ID on the stack
    func dismissPopup(_ id: String, popupManagerID: PopupManagerID = .shared) { PopupManager.dismissPopup(id, popupManagerID: popupManagerID) }

    /// Dismisses all the popups of provided type on the stack
    func dismissPopup<P: Popup>(_ type: P.Type, popupManagerID: PopupManagerID = .shared) { PopupManager.dismissPopup(type, popupManagerID: popupManagerID) }

    /// Dismisses all the popups on the stack
    func dismissAllPopups(popupManagerID: PopupManagerID = .shared) { PopupManager.dismissAllPopups(popupManagerID: popupManagerID) }
}
