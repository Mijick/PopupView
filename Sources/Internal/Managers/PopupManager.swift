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
    @Published var views: [AnyPopup] = [] { willSet { onViewsChanged(newValue) }}

    private let id: Reg
    init(id: Reg) { self.id = id }
}
private extension PopupManager {
    func onViewsChanged(_ newViews: [AnyPopup]) { newViews
        .difference(from: views)
        .forEach { switch $0 {
            case .remove(_, let element, _): element.onDismiss?()
            default: return
        }}
    }
}

// MARK: - Operations
enum StackOperation {
    case insertAndReplace(AnyPopup), insertAndStack(AnyPopup)
    case removeLast, remove(ID), removeAllUpTo(ID), removeAll
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
            case .remove(let id): removeAll(where: { $0.id ~= id })
            case .removeAllUpTo(let id): removeAllUpToElement(where: { $0.id ~= id })
            case .removeAll: removeAll()
        }
    }
}
private extension [AnyPopup] {
    func canBeInserted(_ popup: AnyPopup) -> Bool { !contains(where: { $0.id ~= popup.id }) }
}








class Registry {
    static var instances: [PopupManager] = [.init(id: .shared)]
}



public struct Reg: Equatable {
    var rawValue: String

    static let shared: Reg = .init(rawValue: "shared")


    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}





extension PopupManager {
    static func getInstance(id: Reg = .shared) -> PopupManager {
        Registry.instances.first(where: { $0.id == id })!
    }
}
