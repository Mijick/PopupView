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
    @Published private(set) var size: CGSize = UIScreen.size
    @Published private(set) var safeArea: UIEdgeInsets = UIScreen.safeArea
    private(set) var cornerRadius: CGFloat? = UIScreen.cornerRadius
    private var subscription: [AnyCancellable] = []

    static let shared: ScreenManager = .init()
    private init() { subscribeToScreenOrientationChangeEvents() }
}

private extension ScreenManager {
    func subscribeToScreenOrientationChangeEvents() {
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: updateScreenValues)
            .store(in: &subscription)
    }
}
private extension ScreenManager {
    func updateScreenValues(_ value: NotificationCenter.Publisher.Output) {
        size = UIScreen.size
        safeArea = UIScreen.safeArea
    }
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
    static var cornerRadius: CGFloat? = main.value(forKey: cornerRadiusKey) as? CGFloat
}
fileprivate extension UIScreen {
    static let cornerRadiusKey: String = ["Radius", "Corner", "display", "_"].reversed().joined()
}


// MARK: - macOS Implementation
#elseif os(macOS)
class ScreenManager: ObservableObject {
    @Published private(set) var size: CGSize = NSScreen.size
    @Published private(set) var safeArea: NSEdgeInsets = NSScreen.safeArea
    private(set) var cornerRadius: CGFloat? = NSScreen.cornerRadius
    private var subscription: [AnyCancellable] = []

    static let shared: ScreenManager = .init()
    private init() { subscribeToWindowUpdateEvents(); subscribeToWindowSizeChangeEvents() }
}

private extension ScreenManager {
    func subscribeToWindowUpdateEvents() {
        NotificationCenter.default
            .publisher(for: NSWindow.didUpdateNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: updateScreenValues)
            .store(in: &subscription)
    }
    func subscribeToWindowSizeChangeEvents() {
        NotificationCenter.default
            .publisher(for: NSWindow.didResizeNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: updateScreenValues)
            .store(in: &subscription)
    }
}
private extension ScreenManager {
    func updateScreenValues(_ value: NotificationCenter.Publisher.Output) { if let window = value.object as? NSWindow, let contentView = window.contentView {
        size = contentView.frame.size
        safeArea = contentView.safeAreaInsets
    }}
}

fileprivate extension NSScreen {
    static var safeArea: NSEdgeInsets =
        NSApplication.shared
            .mainWindow?
            .contentView?
            .safeAreaInsets ?? .init(top: 0, left: 0, bottom: 0, right: 0)
    static var size: CGSize = NSScreen.main?.visibleFrame.size ?? .zero
    static var cornerRadius: CGFloat = 0
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
