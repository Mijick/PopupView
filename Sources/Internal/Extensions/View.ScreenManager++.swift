//
//  View.ScreenManager++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension View {
    func updateScreenSize() -> some View {
        GeometryReader { reader in
            onAppear { ScreenManager.update(reader) }
                .onChange(of: reader.size) { _ in ScreenManager.update(reader) }
                .onChange(of: reader.safeAreaInsets) { _ in ScreenManager.update(reader) }
        }
    }
}
fileprivate extension ScreenManager {
    static func update(_ reader: GeometryProxy) {
        shared.size.height = reader.size.height + reader.safeAreaInsets.top + reader.safeAreaInsets.bottom
        shared.size.width = reader.size.width + reader.safeAreaInsets.leading + reader.safeAreaInsets.trailing

        shared.safeArea.top = reader.safeAreaInsets.top
        shared.safeArea.bottom = reader.safeAreaInsets.bottom
        shared.safeArea.left = reader.safeAreaInsets.leading
        shared.safeArea.right = reader.safeAreaInsets.trailing
    }
}
