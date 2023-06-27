//
//  Main.GlobalConfig.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Animations
public extension GlobalConfig.Main {
    /// Animation for closing and opening popups
    func animation(_ value: AnimationType) -> Self { changing(path: \.animation, to: value) }
}


// MARK: - Internal
public extension GlobalConfig { struct Main: Configurable {
    private(set) var animation: AnimationType = .spring
}}
