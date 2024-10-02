//
//  View++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Actions
extension View {
    func focusSectionIfAvailable() -> some View {
    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        self
    #elseif os(tvOS)
        focusSection()
    #endif
    }
}

// MARK: - Others
extension View {
    func onChange<T: Equatable>(_ value: T, completion: @escaping (T) -> Void) -> some View {
    #if os(visionOS)
        onChange(of: value) { completion(value) }
    #else
        onChange(of: value) { _ in completion(value) }
    #endif
    }
    func overlay<V: View>(view: V) -> some View {
    #if os(visionOS)
        overlay { view }
    #else
        overlay(view)
    #endif
    }
}
