//
//  GlobalConfig+Vertical.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

public extension GlobalConfig { class Vertical: GlobalConfig {
    var dragThreshold: CGFloat = 1/3
    var isStackingEnabled: Bool = true
    var isDragGestureEnabled: Bool = true


    required init() { super.init()
        self.popupPadding = .init()
        self.cornerRadius = 40
    }
}}
