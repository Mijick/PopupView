//
//  HeightReader.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension View {
    func onHeightChange(perform action: @escaping (CGFloat) -> ()) -> some View { modifier(Modifier(onHeightChange: action)) }
}

// MARK: - Implementation
fileprivate struct Modifier: ViewModifier {
    let onHeightChange: (CGFloat) -> ()

    func body(content: Content) -> some View { content.background(
        GeometryReader { geometry in Color.clear
            .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
            .onPreferenceChange(HeightPreferenceKey.self, perform: onHeightChange)
        }
    )}
    struct HeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
    }
}
