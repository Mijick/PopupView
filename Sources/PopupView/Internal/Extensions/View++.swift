//
//  View++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Alignments
extension View {
    func align(to edge: Edge, _ value: CGFloat?) -> some View { padding(.init(edge), value).frame(maxHeight: value != nil ? .infinity : nil, alignment: edge.toAlignment()) }
}
fileprivate extension Edge {
    func toAlignment() -> Alignment {
        switch self {
            case .top: return .top
            case .bottom: return .bottom
            case .leading: return .leading
            case .trailing: return .trailing
        }
    }
}

// MARK: - Actions
extension View {
    func focusSectionIfAvailable() -> some View {
    #if os(iOS) || os(macOS)
        self
    #elseif os(tvOS)
        focusSection()
    #endif
    }
}

// MARK: - Others
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View { if condition { self } }
}
