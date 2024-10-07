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
    required init(backgroundColour: Color, cornerRadius: CGFloat, tapOutsideClosesView: Bool, overlayColour: Color, popupPadding: EdgeInsets) {
        super.init()

        self.backgroundColour = backgroundColour
        self.cornerRadius = cornerRadius
        self.isTapOutsideToDismissEnabled = tapOutsideClosesView
        self.overlayColour = overlayColour
        self.popupPadding = popupPadding
    }
    required convenience init() { self.init(
        backgroundColour: ConfigContainer.centre.backgroundColour,
        cornerRadius: ConfigContainer.centre.cornerRadius,
        tapOutsideClosesView: ConfigContainer.centre.isTapOutsideToDismissEnabled,
        overlayColour: ConfigContainer.centre.overlayColour,
        popupPadding: .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    )}
}}





public typealias CentrePopupConfig = LocalConfig.Centre
