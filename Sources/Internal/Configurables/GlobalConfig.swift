//
//  GlobalConfig.swift of MijickPopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

public class GlobalConfig: Configurable { public required init() {}
    var backgroundColour: Color = .white
    var cornerRadius: CGFloat = 28
    var shadow: Shadow = .none
    var tapOutsideClosesView: Bool = false
    var overlayColour: Color = .black.opacity(0.44)
}

// MARK: Vertical
public extension GlobalConfig { class Vertical: GlobalConfig {
    var distanceFromKeyboard: CGFloat = 8
    var stackCornerRadiusMultiplier: CGFloat = 0.6
    var stackOffset: CGFloat = 8
    var stackScaleFactor: CGFloat = 0.05
    var stackLimit: Int = 4
    var dragGestureEnabled: Bool = true
    var dragGestureProgressToClose: CGFloat = 1/3
}}

// MARK: Centre
public extension GlobalConfig { class Centre: GlobalConfig {
    var transitionEntryScale: CGFloat = 1.16
    var transitionExitScale: CGFloat = 0.82
}}
