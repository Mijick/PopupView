//
//  GlobalConfig+Vertical.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

public extension GlobalConfig { class Vertical: GlobalConfig {
    var dragGestureProgressToClose: CGFloat = 1/3
    var isStackingEnabled: Bool = true
    var isDragGestureEnabled: Bool = true


    required init() { super.init()
        self.popupPadding = .init()
        self.cornerRadius = 40
    }
}}
