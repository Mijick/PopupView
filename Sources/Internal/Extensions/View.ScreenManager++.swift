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
    func updateScreenSize(manager: ScreenManager) -> some View {


        GeometryReader { reader in
                onAppear { manager.update(reader) }
                .onChange(of: reader.size) { _ in manager.update(reader) }
        }
    }
}
