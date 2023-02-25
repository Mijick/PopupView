//
//  TopPopupProtocol.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI





public struct AnyCentrePopup: CentrePopup {
    public func configurePopup(content: CentrePopupConfig) -> CentrePopupConfig {
        configBuilder(content)
    }


    public let id: String
    public var body: some View { _body }

    private var _body: AnyView
    let configBuilder: (CentrePopupConfig) -> CentrePopupConfig

    public init(_ popup: some CentrePopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self.configBuilder = popup.configurePopup
    }
}

public struct AnyTopPopup: TopPopup {
    public func configurePopup(content: TopPopupConfig) -> TopPopupConfig {
        configBuilder(content)
    }


    public let id: String
    public var body: some View { _body }

    private var _body: AnyView
    let configBuilder: (TopPopupConfig) -> TopPopupConfig

    public init(_ popup: some TopPopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self.configBuilder = popup.configurePopup
    }
}
