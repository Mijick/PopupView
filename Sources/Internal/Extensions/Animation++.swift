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
    static var keyboard: Animation { .interpolatingSpring(mass: 3, stiffness: 1000, damping: 500, initialVelocity: 6.4) }
    static var transition: Animation { .spring(duration: 0.48, bounce: 0, blendDuration: 0) }
    static var drag: Animation { .spring(duration: 0.12, bounce: 0, blendDuration: 0) }
}
