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
    func readHeight(onChange action: @escaping (CGFloat) -> ()) -> some View { background(heightReader).onPreferenceChange(HeightPreferenceKey.self, perform: action) }
}
private extension View {
    var heightReader: some View { GeometryReader {
        Color.clear.preference(key: HeightPreferenceKey.self, value: $0.size.height)
    }}
}

// MARK: - Preference Key
fileprivate struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
