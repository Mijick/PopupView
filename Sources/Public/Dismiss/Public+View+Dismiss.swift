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
     Removes the currently active popup from the stack.
     Makes the next popup in the stack the new active popup.

     - Parameters:
     - popupManagerID: The identifier for which the popup was presented. For more information, see ``Popup/present(popupManagerID:)``.

     - Important: Make sure you use the correct **popupManagerID** from which you want to remove the popup.
     */
    func dismissLastPopup(popupManagerID: PopupManagerID = .shared) { PopupManager.dismissLastPopup(popupManagerID: popupManagerID) }

    /**
     Removes all popups with the specified identifier from the stack.

     - Parameters:
     - id: Identifier of the popup located on the stack.
     - popupManagerID: The identifier for which the popup was presented. For more information, see ``Popup/present(popupManagerID:)``.

     - Important: Make sure you use the correct **popupManagerID** from which you want to remove the popup.
     */
    func dismissPopup(_ id: String, popupManagerID: PopupManagerID = .shared) { PopupManager.dismissPopup(id, popupManagerID: popupManagerID) }

    /// Dismisses all the popups of provided type on the stack
    func dismissPopup<P: Popup>(_ type: P.Type, popupManagerID: PopupManagerID = .shared) { PopupManager.dismissPopup(type, popupManagerID: popupManagerID) }

    /// Dismisses all the popups on the stack
    func dismissAllPopups(popupManagerID: PopupManagerID = .shared) { PopupManager.dismissAllPopups(popupManagerID: popupManagerID) }
}
