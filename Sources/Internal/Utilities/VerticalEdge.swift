//
//  VerticalEdge.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

enum VerticalEdge {
    case top
    case bottom
}

// MARK: Negation
extension VerticalEdge {
    static prefix func !(lhs: Self) -> Self { switch lhs {
        case .top: .bottom
        case .bottom: .top
    }}
}

// MARK: Castings
extension VerticalEdge {
    func toEdge() -> Edge { switch self {
        case .top: .top
        case .bottom: .bottom
    }}
    func toAlignment() -> Alignment { switch self {
        case .top: .top
        case .bottom: .bottom
    }}
}
