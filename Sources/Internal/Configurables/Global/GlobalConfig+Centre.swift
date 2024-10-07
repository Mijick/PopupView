//
//  GlobalConfig+Centre.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

public extension GlobalConfig { class Centre: GlobalConfig {
    required init() { super.init()
        self.popupPadding = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        self.cornerRadius = 24
    }
}}
