//
//  Public+Popup+Present.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


import SwiftUI

public extension Popup {
    /**
     Presents the popup.
     The currently active popup (if any) will be stacked.
     */
    func present(popupManagerID: PopupManagerID = .shared) { PopupManager.fetchInstance(id: popupManagerID)?.stack(.insertPopup(self)) }
}

// MARK: Configure Popup
public extension Popup {
    /**
     Sets the custom ID for the selected popup.

     - important: Aby dismiss the popup o danym ID, użyj opcji dismissPOpupID a nie type, bo nie będzie działać
     - tip: Useful if you want to display several different popups of the same type.
     */
    func setCustomID(_ id: String) -> some Popup { AnyPopup(self).settingCustomID(id) }

    /**
     Supplies an observable object to a popup's hierarchy.
     */
    func setEnvironmentObject<T: ObservableObject>(_ object: T) -> some Popup { AnyPopup(self).settingEnvironmentObject(object) }

    /**
     Dismisses the popup after a specified period of time.

     - Parameters:
        - seconds: Time in seconds after which the popup will be closed.
     */
    func dismissAfter(_ seconds: Double) -> some Popup { AnyPopup(self).settingDismissTimer(seconds) }
}
