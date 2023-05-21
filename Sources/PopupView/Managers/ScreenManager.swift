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
    @Published private(set) var screenSize: CGSize = UIScreen.size
    private var subscription: [AnyCancellable] = []

    init() { subscribeToScreenOrientationChangeEvents() }
}

private extension ScreenManager {
    func subscribeToScreenOrientationChangeEvents() {
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in self.screenSize = UIScreen.size }
            .store(in: &subscription)
    }
}


// MARK: - Helpers
fileprivate extension UIScreen {
    static var size: CGSize { main.bounds.size }
}
