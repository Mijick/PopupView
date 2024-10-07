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

public class GlobalConfig {
    var backgroundColour: Color = .white
    var shadow: Shadow = .none
    var cornerRadius: CGFloat = 28
    var overlayColour: Color = .black.opacity(0.44)
    var tapOutsideClosesView: Bool = false
}



// MARK: - AVAILABLE CONFIG TYPES



// MARK: Vertical
public extension GlobalConfig { class Vertical: GlobalConfig {
    var isStackingPossible: Bool = true
    var dragGestureEnabled: Bool = true
    var dragGestureProgressToClose: CGFloat = 1/3
}}

// MARK: Centre
public extension GlobalConfig { class Centre: GlobalConfig {}}
