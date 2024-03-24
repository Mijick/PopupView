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
    private(set) var cornerRadius: CGFloat? = UIScreen.cornerRadius
    private(set) var animationsDisabled: Bool = false

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
    private(set) var cornerRadius: CGFloat? = 0
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


// MARK: - tvOS Implementation
#elseif os(tvOS)
class ScreenManager: ObservableObject {
    @Published private(set) var size: CGSize = .init()
    @Published private(set) var safeArea: UIEdgeInsets = .init()
    private(set) var cornerRadius: CGFloat? = 0
    private(set) var animationsDisabled: Bool = false

    static let shared: ScreenManager = .init()
    private init() {}
}
#endif


// MARK: - Common Implementation
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
