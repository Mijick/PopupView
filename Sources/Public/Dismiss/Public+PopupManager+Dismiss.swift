//
//  Public+PopupManager+Dismiss.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

public extension PopupManager {
    /**
     Dismisses the currently active popup.
     Makes the next popup in the stack the new active popup.

     - Parameters:
        - popupManagerID: The identifier for which the popup was presented. For more information, see ``Popup/present(popupManagerID:)``.

     - Important: Make sure you use the correct **popupManagerID** from which you want to remove the popup.
     */
    static func dismissLastPopup(popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeLastPopup) }

    /// Dismisses all the popups of provided ID on the stack
    static func dismissPopup(_ id: String, popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeAllPopupsWithID(id)) }

    /// Dismisses all the popups of provided type on the stack
    static func dismissPopup<P: Popup>(_ type: P.Type, popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeAllPopupsOfType(type)) }

    /**
     Removes all popups from the stack.
     */
    static func dismissAllPopups(popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeAllPopups) }
}
