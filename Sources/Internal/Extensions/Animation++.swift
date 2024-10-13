//
//  Animation++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

extension Animation {
    static var transition: Animation { .spring(duration: Animation.duration, bounce: 0, blendDuration: 0) }
}
extension Animation {
    static var duration: CGFloat { 0.27 }
}
