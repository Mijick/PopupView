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

    func body(content: Content) -> some View { content
        .background(
            GeometryReader { geo -> Color in
                onHeightChange(geo.size.height)
                return Color.clear
            }
        )
    }
}
