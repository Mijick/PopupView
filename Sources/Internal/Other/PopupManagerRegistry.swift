//
//  PopupManagerRegistry.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

class PopupManagerRegistry {
    static var instances: [PopupManager] = []
}

extension PopupManagerRegistry {
    static func registerNewInstance(_ popupManager: PopupManager) -> PopupManager {
        if let alreadyRegisteredPopupManager = instances.first(where: { $0.id == popupManager.id }) { return alreadyRegisteredPopupManager }

        instances.append(popupManager)
        return popupManager
    }
}
