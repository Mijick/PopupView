//
//  Popup.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol Popup: View {
    associatedtype Config: LocalConfig

    func configurePopup(popup: Config) -> Config
    func onFocus()
    func onDismiss()
}
public extension Popup {
    func configurePopup(popup: Config) -> Config { popup }
    func onFocus() {}
    func onDismiss() {}
}




extension Popup {
    func eraseObject(builder: (inout AnyPopup) -> ()) -> AnyPopup {
        var popup = AnyPopup(self, id: nil)
        builder(&popup)
        return popup
    }
}
