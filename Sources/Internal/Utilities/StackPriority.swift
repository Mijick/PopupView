//
//  StackPriority.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

class StackPriority {
    var top: CGFloat { values[0] }
    var centre: CGFloat { values[1] }
    var bottom: CGFloat { values[2] }
    var overlay: CGFloat { 1 }

    private var values: [CGFloat] = [0, 0, 0]
}

// MARK: Reshuffle
extension StackPriority {
    @MainActor func reshuffle(_ newPopups: [AnyPopup]) { switch newPopups.last {
        case .some(let popup) where popup.config is TopPopupConfig: reshuffle(0)
        case .some(let popup) where popup.config is CentrePopupConfig: reshuffle(1)
        case .some(let popup) where popup.config is BottomPopupConfig: reshuffle(2)
        default: return
    }}
}
private extension StackPriority {
    func reshuffle(_ index: Int) { if values[index] != maxPriority {
        values.enumerated().forEach {
            values[$0.offset] = $0.offset == index ? maxPriority : $0.element - 2
        }
    }}
}
private extension StackPriority {
    var maxPriority: CGFloat { 2 }
}
