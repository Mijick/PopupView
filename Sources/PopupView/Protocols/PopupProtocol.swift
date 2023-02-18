//
//  PopupProtocol.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: fulcrumone@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

protocol PopupProtocol: Identifiable, Hashable, Equatable {
    var id: String { get }
    var view: AnyView { get }
}
extension PopupProtocol {
    static func ==(lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: -Any Implementation
struct AnyPopup: PopupProtocol {
    let id: String
    let view: AnyView

    init(id: String, @ViewBuilder _ builder: () -> some View) {
        self.id = id
        self.view = AnyView(builder())
    }
}
