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

#if os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
class ScreenManager: ObservableObject {
    @Published var size: CGSize = .init()
    @Published var safeArea: UIEdgeInsets = .init()
    private(set) var animationsDisabled: Bool = false

    static let shared: ScreenManager = .init()
    private init() {}
}

#elseif os(macOS)
class ScreenManager: ObservableObject {
    @Published var size: CGSize = .init()
    @Published var safeArea: NSEdgeInsets = .init()
    private(set) var animationsDisabled: Bool = false
    private var subscription: [AnyCancellable] = []

    static let shared: ScreenManager = .init()
    private init() { subscribeToWindowStartResizeEvent(); subscribeToWindowEndResizeEvent() }
}

private extension ScreenManager {
    func subscribeToWindowStartResizeEvent() {
        NotificationCenter.default
            .publisher(for: NSWindow.willStartLiveResizeNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in self.animationsDisabled = true })
            .store(in: &subscription)
    }
    func subscribeToWindowEndResizeEvent() {
        NotificationCenter.default
            .publisher(for: NSWindow.didEndLiveResizeNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in self.animationsDisabled = false })
            .store(in: &subscription)
    }
}

#endif
