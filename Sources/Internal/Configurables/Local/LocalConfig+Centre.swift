//
//  LocalConfig+Centre.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public extension LocalConfig { class Centre: LocalConfig {
    required init() { super.init()
        self.popupPadding = ConfigContainer.centre.popupPadding
        self.cornerRadius = ConfigContainer.centre.cornerRadius
        self.backgroundColor = ConfigContainer.centre.backgroundColor
        self.overlayColor = ConfigContainer.centre.overlayColor
        self.isTapOutsideToDismissEnabled = ConfigContainer.centre.isTapOutsideToDismissEnabled
    }
}}

// MARK: Typealias
public typealias CentrePopupConfig = LocalConfig.Centre



// MARK: - TESTS
#if DEBUG



extension LocalConfig.Centre {
    static func t_createNew(popupPadding: EdgeInsets, cornerRadius: CGFloat) -> LocalConfig.Centre {
        let config = LocalConfig.Centre()
        config.popupPadding = popupPadding
        config.cornerRadius = cornerRadius
        return config
    }
}
#endif