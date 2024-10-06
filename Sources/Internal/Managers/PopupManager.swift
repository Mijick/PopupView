//
//  PopupManager.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

@MainActor public class PopupManager: ObservableObject {
    let id: PopupManagerID
    @Published private(set) var stack: [AnyPopup] = []

    private init(id: PopupManagerID) { self.id = id }
}

extension PopupManager {
    func updateStack(_ popup: AnyPopup) { if let index = stack.firstIndex(of: popup) {
        stack[index] = popup
    }}
}

// MARK: - Operations
extension PopupManager { enum StackOperation {
    case insert(any Popup)
    case removeLast, removeInstance(AnyPopup), removeWithPopupType(any Popup.Type), removeWithID(String), removeAll
}}

extension PopupManager {
    func performOperation(_ operation: StackOperation) {
        hideKeyboard()
        perform(operation)
    }
}
private extension PopupManager {
    @MainActor func hideKeyboard() { KeyboardManager.hideKeyboard() }
    func perform(_ operation: StackOperation) {
        switch operation {
            case .insert(let popup): let popup = AnyPopup(popup, id: id); stack.append(popup, if: canBeInserted(popup))
            case .removeLast: stack.safelyRemoveLast()
            case .removeInstance(let popup): stack.removeAll(where: { $0.id.isSameInstance(as: popup) })
            case .removeWithPopupType(let popupType): stack.removeAll(where: { $0.id.isSameType(as: popupType) })
            case .removeWithID(let id): stack.removeAll(where: { $0.id.isSameType(as: id) })
            case .removeAll: stack.removeAll()
        }
    }
}
private extension PopupManager {
    func canBeInserted(_ popup: AnyPopup) -> Bool { !stack.contains(where: { $0.id.isSameType(as: popup.id) }) }
}














extension PopupManager {
    static func registerNewInstance(id: PopupManagerID) -> PopupManager {
        let instanceToRegister = PopupManager(id: id)

        let registeredInstance = PopupManagerRegistry.registerNewInstance(instanceToRegister)
        return registeredInstance
    }
}






extension PopupManager {
    static func getInstance(_ id: PopupManagerID) -> PopupManager? {
        let managerObject = PopupManagerRegistry.instances.first(where: { $0.id == id })

        Logger.log(if: managerObject == nil, level: .fault, message: "PopupManager instance (\(id.rawValue)) must be registered before use. More details can be found in the documentation.")
        return managerObject
    }
}
