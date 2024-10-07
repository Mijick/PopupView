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

// MARK: Keyboard Publisher
extension View {
    @ViewBuilder func onKeyboardStateChange(_ action: @escaping (Bool) -> ()) -> some View {
        if let keyboardPublisher { onReceive(keyboardPublisher, perform: action) }
        else { self }
    }
}



fileprivate extension View {
    var keyboardPublisher: AnyPublisher<Bool, Never>? {
        #if os(iOS)
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
        #else
        nil
        #endif
    }
}

// MARK: Hide Keyboard
extension AnyView {
    static func hideKeyboard() {
        #if os(iOS)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #elseif os(macOS)
        NSApp.keyWindow?.makeFirstResponder(nil)
        #endif
    }
}
