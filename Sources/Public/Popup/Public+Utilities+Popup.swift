//
//  Public+Utilities+Popup.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

// MARK: Height Mode
public enum HeightMode {
    case auto
    case large
    case fullscreen
}

// MARK: Drag Detent
public enum DragDetent {
    case fixed(CGFloat)
    case fraction(CGFloat)
    case large
    case fullscreen
}
