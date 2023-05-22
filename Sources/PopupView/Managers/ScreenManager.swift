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
    @Published private(set) var screenHeight: CGFloat = UIScreen.main.bounds.size.height
    private var subscription: [AnyCancellable] = []

    init() { subscribeToScreenOrientationChangeEvents() }
}

private extension ScreenManager {
    func subscribeToScreenOrientationChangeEvents() {
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.screenHeight = UIScreen.main.bounds.size.height }
            .store(in: &subscription)
    }
}
