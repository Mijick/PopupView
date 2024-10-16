//
//  GlobalConfig.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

public class GlobalConfig { required init() {}
    var popupPadding: EdgeInsets = .init()
    var cornerRadius: CGFloat = 28
    var backgroundColor: Color = .white
    var overlayColor: Color = .black.opacity(0.44)
    var isTapOutsideToDismissEnabled: Bool = false
}
