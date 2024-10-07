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

@MainActor public class GlobalConfig {
    var cornerRadius: CGFloat = 28
    var backgroundColour: Color = .white
    var shadow: Shadow = .none
    var overlayColour: Color = .black.opacity(0.44)
    var isTapOutsideToDismissEnabled: Bool = false
}



// MARK: - AVAILABLE CONFIG TYPES



// MARK: Vertical
public extension GlobalConfig { class Vertical: GlobalConfig {
    var dragGestureProgressToClose: CGFloat = 1/3
    var isStackingEnabled: Bool = true
    var isDragGestureEnabled: Bool = true
}}

// MARK: Centre
public extension GlobalConfig { class Centre: GlobalConfig {}}
