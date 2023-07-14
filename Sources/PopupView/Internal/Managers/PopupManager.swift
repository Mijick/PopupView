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
    @Published private(set) var views: [any Popup] = []
    private(set) var presenting: Bool = true

    static let shared: PopupManager = .init()
    private init() {}
}
extension PopupManager {
    var top: [AnyPopup<TopPopupConfig>] { views.compactMap { $0 as? AnyPopup<TopPopupConfig> } }
    var centre: [AnyPopup<CentrePopupConfig>] { views.compactMap { $0 as? AnyPopup<CentrePopupConfig> } }
    var bottom: [AnyPopup<BottomPopupConfig>] { views.compactMap { $0 as? AnyPopup<BottomPopupConfig> } }
}

// MARK: - Operations
enum StackOperation {
    case insertAndReplace(any Popup), insertAndStack(any Popup)
    case removeLast, remove(id: String), removeAllUpTo(id: String), removeAll
}
extension PopupManager {
    static func performOperation(_ operation: StackOperation) { DispatchQueue.main.async {
        updateOperationType(operation)
        shared.views.perform(operation)
        shared.updateActive()
    }}
}
private extension PopupManager {
    static func updateOperationType(_ operation: StackOperation) {
        switch operation {
            case .insertAndReplace, .insertAndStack: shared.presenting = true
            case .removeLast, .remove, .removeAllUpTo, .removeAll: shared.presenting = false
        }
    }
}

fileprivate extension PopupManager {
    private func updateActive() {
//        print("====> updateActive \(top.count),  \(bottom.count)")
        top.forEach { $0.active(top.last == $0) }
        centre.forEach { $0.active(centre.last == $0) }
        bottom.forEach { $0.active(bottom.last == $0) }
    }
}

fileprivate extension [any Popup] {
    mutating func perform(_ operation: StackOperation) {
        hideKeyboard()
        performOperation(operation)
    }
}
private extension [any Popup] {
    func hideKeyboard() { KeyboardManager.hideKeyboard() }
    mutating func performOperation(_ operation: StackOperation) {
        switch operation {
        case .insertAndReplace(let popup):
            replaceLast(popup, if: canBeInserted(popup))
            
        case .insertAndStack(let popup):
//            중복될때 타이머 처리 처리
            append(popup, if: canBeInserted(popup))
        
        case .removeLast:
            guard let removePopup = removeLast() else { return }
            removePopup.close()
            
        case .remove(let id):
            let removeItems = self.filter { $0.id == id }
            removeAll(where: { $0.id == id })
            removeItems.forEach {
                $0.close()
            }
            
        case .removeAllUpTo(let id):
            let removeItems = removeAllUpToElement(where: { $0.id == id })
            removeItems.forEach {
                $0.close()
            }
            
        case .removeAll:
            let removeItems = self
            removeAll()
            removeItems.forEach {
                $0.close()
            }
        }
    }
}
private extension [any Popup] {
    func canBeInserted(_ popup: some Popup) -> Bool { !contains(where: { $0.id == popup.id }) }
}
