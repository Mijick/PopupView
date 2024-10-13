//
//  Public+PopupManager.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


// MARK: Dismiss Popup(s)
public extension PopupManager {
    /// Dismisses the last popup on the stack
    static func dismissLastPopup(popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeLastPopup) }

    /// Dismisses all the popups of provided ID on the stack
    static func dismissPopup(_ id: String, popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeAllPopupsWithID(id)) }

    /// Dismisses all the popups of provided type on the stack
    static func dismissPopup<P: Popup>(_ type: P.Type, popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeAllPopupsOfType(type)) }

    /// Dismisses all the popups on the stack
    static func dismissAllPopups(popupManagerID: PopupManagerID = .shared) { fetchInstance(id: popupManagerID)?.stack(.removeAllPopups) }
}
