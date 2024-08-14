//
//  Public+DragDetent.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

public enum DragDetent {
    case fixed(CGFloat)
    case fraction(CGFloat)
    case fullscreen(stackVisible: Bool)
}
