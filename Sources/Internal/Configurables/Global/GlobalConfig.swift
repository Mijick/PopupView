//
//  GlobalConfig.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

@MainActor public class GlobalConfig { required init() {}
    var popupPadding: EdgeInsets = .init()
    var cornerRadius: CGFloat = 28
    var backgroundColor: Color = .white
    var shadow: Shadow = .init()
    var overlayColor: Color = .black.opacity(0.44)
    var isTapOutsideToDismissEnabled: Bool = false
}
