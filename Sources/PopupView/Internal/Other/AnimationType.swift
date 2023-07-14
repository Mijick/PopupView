//
//  AnimationType.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public struct AnimationType {
    public private(set) var entry: Animation
    public private(set) var removal: Animation
    
    public init(entry: Animation = .spring(response: 0.4, dampingFraction: 1, blendDuration: 0.1),
                removal: Animation = .interactiveSpring(response: 0.14, dampingFraction: 1, blendDuration: 1)) {
        self.entry = entry
        self.removal = removal
    }
}
//extension AnimationType {
//    var entry: Animation {
//        switch self {
//            case .spring: return .spring(response: 0.4, dampingFraction: 1, blendDuration: 0.1)
//            case .linear: return .linear(duration: 0.4)
//            case .easeInOut: return .easeInOut(duration: 0.4)
//        }
//    }
//    var removal: Animation {
//        switch self {
//            case .spring: return .interactiveSpring(response: 0.14, dampingFraction: 1, blendDuration: 1)
//            case .linear: return .linear(duration: 0.3)
//            case .easeInOut: return .easeInOut(duration: 0.3)
//        }
//    }
//}
