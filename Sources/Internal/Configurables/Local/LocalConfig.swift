//
//  LocalConfig.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public class LocalConfig { required init() {}
    var popupPadding: EdgeInsets = .init()
    var cornerRadius: CGFloat = 0
    var backgroundColor: Color = .clear
    var overlayColor: Color = .clear
    var isTapOutsideToDismissEnabled: Bool = false
}
