//
//  ID+PopupManager.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

public struct PopupManagerID: Equatable, Sendable {
    let rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }
}
