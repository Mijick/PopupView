//
//  ScreenManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI
import Combine

class ScreenManager: ObservableObject {
    private(set) var properties: ScreenProperties = .init()
}

extension ScreenManager {
    func update(_ reader: GeometryProxy) {
        properties.height = reader.size.height + reader.safeAreaInsets.top + reader.safeAreaInsets.bottom
        properties.safeArea = reader.safeAreaInsets

        objectWillChange.send()
    }
}
