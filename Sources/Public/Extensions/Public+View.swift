//
//  Public+View.swift of
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: Setup Framework
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
public extension View {
    /// Initialises the library. Use directly with the view in your @main structure
    func registerPopups(id: PopupManagerID = .shared, configBuilder: @escaping (ConfigContainer) -> ConfigContainer = { $0 }) -> some View { self
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(PopupView(popupManager: .registerInstance(id: id)), alignment: .top)
        .onAppear { _ = configBuilder(.init()) }
    }
}
#elseif os(tvOS)
public extension View {
    /// Initialises the library. Use directly with the view in your @main structure
    func registerPopups(id: PopupManagerID = .shared, configBuilder: @escaping (ConfigContainer) -> ConfigContainer = { $0 }) -> some View {
        PopupView(rootView: self, popupManager: .registerInstance(id: id)).onAppear { _ = configBuilder(.init()) }
    }
}
#endif

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
