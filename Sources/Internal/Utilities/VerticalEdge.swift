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

    init(_ config: LocalConfig.Type) { switch config.self {
        case is TopPopupConfig.Type: self = .top
        case is BottomPopupConfig.Type: self = .bottom
        default: fatalError()
    }}
}

// MARK: Negation
extension VerticalEdge {
    static prefix func !(lhs: Self) -> Self { switch lhs {
        case .top: .bottom
        case .bottom: .top
    }}
}

// MARK: Type Casting
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
