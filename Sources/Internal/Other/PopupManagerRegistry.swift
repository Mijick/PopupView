//
//  PopupManagerRegistry.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import Foundation

@MainActor class PopupManagerRegistry {
    static private(set) var instances: [PopupManager] = []
}

// MARK: Register
extension PopupManagerRegistry {
    static func register(popupManager: PopupManager) -> PopupManager {
        if let alreadyRegisteredInstance = instances.first(where: { $0.id == popupManager.id }) { return alreadyRegisteredInstance }

        instances.append(popupManager)
        return popupManager
    }
}

// MARK: Clean
extension PopupManagerRegistry {
    static func clean() { instances = [] }
}
