//
//  TopPopupProtocol.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol TopPopup: Popup {
    associatedtype Config = TopPopupConfig
}




final class AnyPopup<Config: Configurable>: Popup {
    let id: String
    var body: some View { _body }

    private let _body: AnyView
    private let _configBuilder: (Config) -> Config


    init(_ popup: some Popup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self._configBuilder = popup.configurePopup as! (Config) -> Config
    }
}
extension AnyPopup {
    func configurePopup(content: Config) -> Config { _configBuilder(content) }
}



