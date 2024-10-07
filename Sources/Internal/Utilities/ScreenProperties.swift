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

class ScreenProperties {
    var height: CGFloat = .zero
    var safeArea: EdgeInsets = .init()


    init(height: CGFloat = .zero, safeArea: EdgeInsets = .init()) {
        self.height = height
        self.safeArea = safeArea
    }
}



extension ScreenProperties {
    func update(_ reader: GeometryProxy) {
        height = reader.size.height + reader.safeAreaInsets.top + reader.safeAreaInsets.bottom
        safeArea = reader.safeAreaInsets
    }
}
