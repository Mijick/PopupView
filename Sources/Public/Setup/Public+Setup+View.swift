//
//  Public+Setup+View.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

// MARK: Setup Library
public extension View {
    /// Initialises the library. Use directly with the view in your @main structure
    func registerPopups(id: PopupManagerID = .shared, configBuilder: @escaping (GlobalConfigContainer) -> GlobalConfigContainer = { $0 }) -> some View {
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

// MARK: Popup Identifiers (Extendable)
public extension PopupManagerID {
    static let shared: Self = .init(rawValue: "shared")
}
