//
//  View+ReadHeight.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension View {
    func onHeightChange(perform action: @escaping (CGFloat) -> ()) -> some View { background(
        GeometryReader { proxy in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { action(proxy.size.height) }
            return Color.clear
        }
    )}
}
