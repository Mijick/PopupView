//
//  View++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension View {

#if os(iOS) || os(macOS)
    func implementPopupView() -> some View { overlay(PopupView()) }
#elseif os(tvOS)
    func implementPopupView() -> some View { PopupView(rootView: self) }
#endif
    
}

// MARK: - Alignments
extension View {
    func alignToBottom(if shouldAlign: Bool = true, _ value: CGFloat = 0) -> some View {
        VStack(spacing: 0) {
            if shouldAlign { Spacer() }
            self
            Spacer.height(value)
        }
    }
    func alignToTop(_ value: CGFloat = 0) -> some View {
        VStack(spacing: 0) {
            Spacer.height(value)
            self
            Spacer()
        }
    }
}

// MARK: - Frames
extension View {
    func frame(size: CGSize) -> some View { frame(width: size.width, height: size.height) }
}

// MARK: - Cleaning Cache
extension View {
    func clearCacheObjects(shouldClear: Bool, trigger: Binding<Bool>) -> some View {
        onChange(of: shouldClear) { $0 ? trigger.toggleAfter(seconds: 0.4) : () }
        .id(trigger.wrappedValue)
    }
}

// MARK: - Others
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View {
        if condition { self }
    }
    func visible(if condition: Bool) -> some View {
        opacity(condition.doubleValue)
    }
}

extension View {

#if os(iOS) || os(macOS)
    func focusSectionIfAvailable() -> some View { self }
#elseif os(tvOS)
    func focusSectionIfAvailable() -> some View { focusSection() }
#endif

}
