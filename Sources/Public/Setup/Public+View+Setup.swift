//
//  Public+View+Setup.swift of MijickPopups
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
     Register the framework to work in your application.

     - Parameters:
        - id: Text...
        - configBuilder: Text...


     ## Implementation Example
     ```swift
     import SwiftUI
     import MijickPopups

     @main struct App_Main: App {
        var body: some Scene { WindowGroup {
            ContentView()
                .registerPopups { config in config
                    .vertical { $0
                        .enableDragGesture(true)
                        .tapOutsideToDismissPopup(true)
                        .cornerRadius(32)
                    }
                    .centre { $0
                        .tapOutsideToDismissPopup(false)
                        .backgroundColor(.red)
                    }
                }
        }}
     }
     ```

    - seealso: Text!
     */
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
