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

class KeyboardManager: ObservableObject {
    @Published private(set) var keyboardHeight: CGFloat = 0
    private var subscription: [AnyCancellable] = []

    init() { subscribeToKeyboardEvents() }
}

// MARK: - Creating Publishers
private extension KeyboardManager {
    func subscribeToKeyboardEvents() {
        Publishers.Merge(getKeyboardWillOpenPublisher(), createKeyboardWillHidePublisher())
            .debounce(for: .milliseconds(20), scheduler: DispatchQueue.main)
            .sink { self.keyboardHeight = $0 }
            .store(in: &subscription)
    }
}
private extension KeyboardManager {
    func getKeyboardWillOpenPublisher() -> Publishers.CompactMap<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { max(0, $0.height - 8) }
    }
    func createKeyboardWillHidePublisher() -> Publishers.Map<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in .zero }
    }
}
