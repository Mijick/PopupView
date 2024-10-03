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

    var id: ID { get }

    func createContent() -> V
    func configurePopup(popup: Config) -> Config
}
public extension Popup {
    var id: ID { .init(self) }
    var body: V { createContent() }

    func configurePopup(popup: Config) -> Config { popup }
}




extension Popup {
    func eraseObject(builder: (inout AnyPopup) -> ()) -> AnyPopup {
        var popup = AnyPopup(self, id: nil)
        builder(&popup)
        return popup
    }
}
