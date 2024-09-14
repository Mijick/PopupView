//
//  PopupStack.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

protocol PopupStack: View {
    associatedtype Config: LocalConfig

    var items: [AnyPopup] { get }
}






// MARK: - Initial Height
extension PopupStack {
    func getInitialHeight() -> CGFloat { items.nextToLast?.height ?? 30 }
}


// MARK: - Configurables
extension PopupStack {
    func getConfig(_ item: AnyPopup) -> Config { (item.config as? Config) ?? .init() }
    var lastPopupConfig: Config { (items.last?.config as? Config) ?? .init() }
}
