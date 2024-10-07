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
        return PopupView(rootView: updateScreenSize()).onAppear { _ = config(.init()) }
    }
}
#endif

// MARK: Dismiss Popup(s)
public extension View {
    /// Dismisses the last popup on the stack
    func dismiss(id: PopupManagerID = .shared) { PopupManager.dismissLastPopup(popupManagerID: id) }

    /// Dismisses all the popups of provided type on the stack
    func dismissPopup<P: Popup>(_ popup: P.Type, id: PopupManagerID = .shared) { PopupManager.dismissPopup(popup, popupManagerID: id) }

    /// Dismisses all the popups on the stack
    func dismissAll(id: PopupManagerID = .shared) { PopupManager.dismissAllPopups(popupManagerID: id) }
}
