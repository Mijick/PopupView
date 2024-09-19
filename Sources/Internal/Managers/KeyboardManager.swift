//
//  KeyboardManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI
import Combine

// MARK: -iOS Implementation
#if os(iOS) || os(visionOS)
class KeyboardManager: ObservableObject {
    @Published private(set) var height: CGFloat = 0
    private var subscription: [AnyCancellable] = []

    static let shared: KeyboardManager = .init()
    private init() { subscribeToKeyboardEvents() }
}
extension KeyboardManager {
    static func hideKeyboard() { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
}

private extension KeyboardManager {
    func subscribeToKeyboardEvents() {
        Publishers.Merge(getKeyboardWillOpenPublisher(), createKeyboardWillHidePublisher())
            .receive(on: DispatchQueue.main)
            .sink { self.height = $0 }
            .store(in: &subscription)
    }
}
private extension KeyboardManager {
    func getKeyboardWillOpenPublisher() -> Publishers.CompactMap<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
    }
    func createKeyboardWillHidePublisher() -> Publishers.Map<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in .zero }
    }
}


// MARK: - macOS Implementation
#elseif os(macOS)
class KeyboardManager: ObservableObject {
    private(set) var height: CGFloat = 0

    static let shared: KeyboardManager = .init()
    private init() {}
}
extension KeyboardManager {
    static func hideKeyboard() { NSApp.keyWindow?.makeFirstResponder(nil) }
}


// MARK: - tvOS Implementation
#elseif os(tvOS) || os(watchOS)
class KeyboardManager: ObservableObject {
    private(set) var height: CGFloat = 0

    static let shared: KeyboardManager = .init()
    private init() {}
}
extension KeyboardManager {
    static func hideKeyboard() {}
}
#endif
