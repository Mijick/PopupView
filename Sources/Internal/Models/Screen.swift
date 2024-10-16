//
//  Screen.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

struct Screen {
    let height: CGFloat
    let safeArea: EdgeInsets


    init(height: CGFloat = .zero, safeArea: EdgeInsets = .init()) {
        self.height = height
        self.safeArea = safeArea
    }
    init(_ reader: GeometryProxy) {
        self.height = reader.size.height + reader.safeAreaInsets.top + reader.safeAreaInsets.bottom
        self.safeArea = reader.safeAreaInsets
    }
}
