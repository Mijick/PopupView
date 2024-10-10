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

public struct PopupManagerID: Equatable, Sendable {
    let rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }
}

// MARK: Default IDs
public extension PopupManagerID {
    static let shared: Self = .init(rawValue: "shared")
}
