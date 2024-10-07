//
//  ScreenProperties.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

struct ScreenProperties {
    let height: CGFloat
    let safeArea: EdgeInsets


    init(height: CGFloat = .zero, safeArea: EdgeInsets = .init()) {
        self.height = height
        self.safeArea = safeArea
    }
    init(_ reader: GeometryProxy) {
        height = reader.size.height + reader.safeAreaInsets.top + reader.safeAreaInsets.bottom
        safeArea = reader.safeAreaInsets
    }
}
