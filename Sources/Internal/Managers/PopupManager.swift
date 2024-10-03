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

    let instance: PopupManagerInstance
    init(instance: PopupManagerInstance) { self.instance = instance }
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








class PopupManagerRegistry {
    static var instances: [PopupManager] = []


    static func register(instance: PopupManagerInstance) -> PopupManager? {
        if !instances.contains(where: { $0.instance == instance }) {
            let a = PopupManager(instance: instance)
            instances.append(a)
            return a
        }

        return nil
    }
}



public struct PopupManagerInstance: Equatable {
    private var rawValue: String

    public static let shared: PopupManagerInstance = .init("shared")


    public init(_ rawValue: String) { self.rawValue = rawValue }
}





extension PopupManager {
    static func getInstance(_ instance: PopupManagerInstance = .shared) -> PopupManager {
        PopupManagerRegistry.instances.first(where: { $0.instance == instance })!
    }
}
