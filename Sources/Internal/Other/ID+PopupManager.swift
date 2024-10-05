//
//  ID+PopupManager.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

@MainActor public struct PopupManagerID: Equatable {
    var rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }
}

// MARK: Possible Options
public extension PopupManagerID {
    static let shared: Self = .init(rawValue: "shared")
}
