//
//  Public+View.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


import SwiftUI

// MARK: Setup Framework
public extension View {
    /// Initialises the library. Use directly with the view in your @main structure
    func registerPopups(id: PopupManagerID = .shared, configBuilder: @escaping (ConfigContainer) -> ConfigContainer = { $0 }) -> some View {
        #if os(tvOS)
        PopupView(rootView: self, popupManager: .registerInstance(id: id)).onAppear { _ = configBuilder(.init()) }
        #else
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(PopupView(popupManager: .registerInstance(id: id)), alignment: .top)
            .onAppear { _ = configBuilder(.init()) }
        #endif
    }
}

// MARK: Dismiss Popup(s)
public extension View {
    /// Dismisses the last popup on the stack
    func dismissLastPopup(popupManagerID: PopupManagerID = .shared) { PopupManager.dismissLastPopup(popupManagerID: popupManagerID) }

    /// Dismisses all the popups of provided ID on the stack
    func dismissPopup(_ id: String, popupManagerID: PopupManagerID = .shared) { PopupManager.dismissPopup(id, popupManagerID: popupManagerID) }

    /// Dismisses all the popups of provided type on the stack
    func dismissPopup<P: Popup>(_ type: P.Type, popupManagerID: PopupManagerID = .shared) { PopupManager.dismissPopup(type, popupManagerID: popupManagerID) }

    /// Dismisses all the popups on the stack
    func dismissAllPopups(popupManagerID: PopupManagerID = .shared) { PopupManager.dismissAllPopups(popupManagerID: popupManagerID) }
}
