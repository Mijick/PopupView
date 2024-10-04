//
//  PopupManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public class PopupManager: ObservableObject {
    @Published var views: [AnyPopup] = []

    let id: PopupManagerID
    private init(id: PopupManagerID) { self.id = id }
}

// MARK: - Operations
enum StackOperation {
    case insertAndReplace(AnyPopup), insertAndStack(AnyPopup)
    case removeLast, removeExact(PopupID), remove(PopupID), removeAll
}
extension PopupManager {
    func performOperation(_ operation: StackOperation) {
        views.perform(operation)
    }
}

fileprivate extension [AnyPopup] {
    mutating func perform(_ operation: StackOperation) {
        hideKeyboard()
        performOperation(operation)
    }
}
private extension [AnyPopup] {
    func hideKeyboard() { KeyboardManager.hideKeyboard() }
    mutating func performOperation(_ operation: StackOperation) {
        switch operation {
            case .insertAndReplace(let popup): replaceLast(popup, if: canBeInserted(popup))
            case .insertAndStack(let popup): append(popup, if: canBeInserted(popup))
            case .removeLast: removeLast()
            case .removeExact(let id): removeAll(where: { $0.id == id })
            case .remove(let id): removeAll(where: { $0.id ~= id })
            case .removeAll: removeAll()
        }
    }
}
private extension [AnyPopup] {
    func canBeInserted(_ popup: AnyPopup) -> Bool { !contains(where: { $0.id ~= popup.id }) }
}













extension PopupManager {
    static func registerNewInstance(id: PopupManagerID) -> PopupManager {
        let instanceToRegister = PopupManager(id: id)

        let registeredInstance = PopupManagerRegistry.registerNewInstance(instanceToRegister)
        return registeredInstance
    }
}








extension PopupManager {
    static func getInstance(_ instance: PopupManagerID = .shared) -> PopupManager {
        PopupManagerRegistry.instances.first(where: { $0.id == instance })!
    }
}
