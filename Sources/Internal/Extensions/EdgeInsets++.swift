//
//  EdgeInsets++.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension EdgeInsets {
    subscript(_ edge: VerticalEdge) -> CGFloat { switch edge {
        case .top: top
        case .bottom: bottom
    }}
}
