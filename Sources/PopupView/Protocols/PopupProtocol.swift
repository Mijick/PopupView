//
//  PopupProtocol.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public protocol PopupProtocol: Identifiable, Hashable, Equatable {
    var id: String { get }
    var view: AnyView { get }
}
public extension PopupProtocol {
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: -Any Implementation
public struct AnyPopup: PopupProtocol {
    public let id: String
    public let view: AnyView

    public init(id: String, @ViewBuilder _ builder: () -> some View) {
        self.id = id
        self.view = AnyView(builder())
    }
}







public struct AnyBottomPopup: BottomPopup {
    public func configurePopup(content: PopupBottomStackView.Config) -> PopupBottomStackView.Config {
        configBuilder(content)
    }

    public let id: String
    public var body: some View { _body }
    let configBuilder: (PopupBottomStackView.Config) -> PopupBottomStackView.Config

    private var _body: AnyView

    public init(_ popup: some BottomPopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
        self.configBuilder = popup.configurePopup
    }
}

public struct AnyCentrePopup: CentrePopup {
    public let id: String
    public var body: some View { _body }

    private var _body: AnyView

    public init(_ popup: some CentrePopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
    }
}

public struct AnyTopPopup: TopPopup {
    public let id: String
    public var body: some View { _body }

    private var _body: AnyView

    public init(_ popup: some TopPopup) {
        self.id = popup.id
        self._body = AnyView(popup.body)
    }
}
