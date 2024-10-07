//
//  LocalConfig.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

@MainActor public class LocalConfig { required init() {}
    var popupPadding: EdgeInsets = .init()
    var cornerRadius: CGFloat = 0
    var backgroundColour: Color = .clear
    var overlayColour: Color = .clear
    var isTapOutsideToDismissEnabled: Bool = false
}
