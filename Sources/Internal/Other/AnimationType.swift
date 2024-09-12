//
//  AnimationType.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public enum AnimationType { case spring, linear, easeInOut }
extension AnimationType {
    var transition: Animation { switch self {
        case .spring: return .spring(duration: 0.4, bounce: 0, blendDuration: 0.1)
        case .linear: return .linear(duration: 0.4)
        case .easeInOut: return .easeInOut(duration: 0.4)
    }}
    var dragGesture: Animation { .linear(duration: 0.02) }
}
