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
    associatedtype V: View

    func createContent() -> V
    func configurePopup(popup: Config) -> Config
    func onFocus()
    func onDismiss()
}
public extension Popup {
    var body: V { createContent() }

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




extension Popup {
    func t_present(id: PopupManagerID) { present(id: id) }
}
