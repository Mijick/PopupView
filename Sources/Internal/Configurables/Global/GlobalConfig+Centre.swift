//
//  GlobalConfig+Centre.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

public extension GlobalConfig { class Centre: GlobalConfig {
    required init() { super.init()
        self.popupPadding = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        self.cornerRadius = 24
    }
}}
