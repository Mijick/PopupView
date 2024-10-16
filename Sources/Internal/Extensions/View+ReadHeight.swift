//
//  View+ReadHeight.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


import SwiftUI

extension View {
    func onHeightChange(perform action: @escaping (CGFloat) -> ()) -> some View { background(
        GeometryReader { proxy in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { action(proxy.size.height) }
            return Color.clear
        }
    )}
}
