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
    associatedtype Config: Configurable

    var items: [AnyPopup] { get }
    var globalConfig: GlobalConfig { get }
    var gestureTranslation: CGFloat { get }
    var isGestureActive: Bool { get }
    var translationProgress: CGFloat { get }
    var cornerRadius: CGFloat { get }

    var stackLimit: Int { get }
    var stackScaleFactor: CGFloat { get }
    var stackCornerRadiusMultiplier: CGFloat { get }
    var stackOffsetValue: CGFloat { get }

    var tapOutsideClosesPopup: Bool { get }
}
extension PopupStack {
    var gestureTranslation: CGFloat { 0 }
    var isGestureActive: Bool { false }
    var translationProgress: CGFloat { 1 }

    var stackLimit: Int { 1 }
    var stackScaleFactor: CGFloat { 1 }
    var stackCornerRadiusMultiplier: CGFloat { 0 }
    var stackOffsetValue: CGFloat { 0 }
}


// MARK: - Tapable Area
extension PopupStack {
    @ViewBuilder func createTapArea() -> some View { if tapOutsideClosesPopup {
        Color.black.opacity(0.00000000001).onTapGesture(perform: items.last?.dismiss ?? {})
    }}
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
