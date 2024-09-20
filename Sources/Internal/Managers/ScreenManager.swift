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
    private(set) var size: CGSize = .init()
    private(set) var safeArea: EdgeInsets = .init()

    static let shared: ScreenManager = .init()
    private init() {}
}

extension ScreenManager {
    static func update(_ reader: GeometryProxy) {
        shared.size.width = reader.size.width + reader.safeAreaInsets.leading + reader.safeAreaInsets.trailing
        shared.size.height = reader.size.height + reader.safeAreaInsets.top + reader.safeAreaInsets.bottom
        shared.safeArea = reader.safeAreaInsets

        shared.objectWillChange.send()
    }
}
