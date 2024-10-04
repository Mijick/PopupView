//
//  Public+View.swift of
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Initialising
public extension View {
    /// Initialises the library. Use directly with the view in your @main structure
    func implementPopupView(id: PopupManagerID = .shared, config: @escaping (ConfigContainer) -> ConfigContainer = { $0 }) -> some View {
        let popupManager = PopupManager.registerNewInstance(id: id)

    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(PopupView(popupManager: popupManager), alignment: .top)
            .onAppear { _ = config(.init()) }
    #elseif os(tvOS)
        return PopupView(rootView: updateScreenSize()).onAppear { _ = config(.init()) }
    #endif
    }
}

// MARK: - Dismissing Popups
public extension View {
    /// Dismisses the last popup on the stack
    func dismiss() { PopupManager.dismiss() }

    /// Dismisses all the popups of provided type on the stack
    func dismissPopup<P: Popup>(_ popup: P.Type) { PopupManager.dismissPopup(popup) }

    /// Dismisses all the popups on the stack
    func dismissAll() { PopupManager.dismissAll() }
}

// MARK: - Actions
public extension View {
    /// Triggers every time the popup is at the top of the stack
    func onFocus(_ popup: some Popup, perform action: @escaping () -> ()) -> some View {
        onReceive(PopupManager.getInstance().$views) { views in
            if views.last?.id == popup.id { action() }
        }
    }
}
