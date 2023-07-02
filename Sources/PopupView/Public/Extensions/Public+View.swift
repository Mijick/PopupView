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
    func implementPopupView(config: (GlobalConfig) -> GlobalConfig = { $0 }) -> some View {
    #if os(iOS) || os(macOS)
        overlay(PopupView(globalConfig: config(.init())))
    #elseif os(tvOS)
        PopupView(rootView: self, globalConfig: config(.init()))
    #endif
    }
}

// MARK: - Actions
public extension View {
    /// Triggers every time the popup is at the top of the stack
    func onFocus(_ popup: some Popup, perform action: @escaping () -> ()) -> some View {
        onReceive(PopupManager.shared.$views) { views in
            if views.last?.id == popup.id { action() }
        }
    }
}
