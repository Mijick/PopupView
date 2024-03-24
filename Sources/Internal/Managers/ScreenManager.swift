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

// MARK: -iOS Implementation
#if os(iOS)
class ScreenManager: ObservableObject {
    @Published var size: CGSize = .init()
    @Published var safeArea: UIEdgeInsets = .init()
    private(set) var animationsDisabled: Bool = false
    private(set) var cornerRadius: CGFloat? = UIScreen.cornerRadius

    static let shared: ScreenManager = .init()
    private init() {}
}
private extension UIScreen {
    static var cornerRadius: CGFloat? = main.value(forKey: ["Radius", "Corner", "display", "_"].reversed().joined()) as? CGFloat
}


// MARK: - macOS Implementation
#elseif os(macOS)
class ScreenManager: ObservableObject {
    @Published var size: CGSize = .init()
    @Published var safeArea: NSEdgeInsets = .init()
    private(set) var animationsDisabled: Bool = false
    private(set) var cornerRadius: CGFloat? = 0
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


// MARK: - tvOS Implementation
#elseif os(tvOS)
class ScreenManager: ObservableObject {
    @Published private(set) var size: CGSize = UIScreen.size
    @Published private(set) var safeArea: UIEdgeInsets = UIScreen.safeArea
    private(set) var cornerRadius: CGFloat? = UIScreen.cornerRadius

    static let shared: ScreenManager = .init()
    private init() {}
}

fileprivate extension UIScreen {
    static var safeArea: UIEdgeInsets {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .zero
    }
    static var size: CGSize { UIScreen.main.bounds.size }
    static var cornerRadius: CGFloat = 0
}
#endif
