//
//  View++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension View {

#if os(iOS) || os(macOS)
    func implementPopupView(config: (GlobalConfig) -> GlobalConfig = { $0 }) -> some View { overlay(PopupView(globalConfig: config(.init()))) }
#elseif os(tvOS)
    func implementPopupView(config: (GlobalConfig) -> GlobalConfig = { $0 }) -> some View { PopupView(rootView: self, globalConfig: config(.init())) }
#endif
    
}

public extension View {
    /// Triggers every time the popup is at the top of the stack
    func onFocus(_ popup: some Popup, perform action: @escaping () -> ()) -> some View {
        onReceive(PopupManager.shared.$views) { views in
            if views.last?.id == popup.id { action() }
        }
    }
}


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

// MARK: - Others
extension View {
    @ViewBuilder func active(if condition: Bool) -> some View {
        if condition { self }
    }
}

extension View {

#if os(iOS) || os(macOS)
    func focusSectionIfAvailable() -> some View { self }
#elseif os(tvOS)
    func focusSectionIfAvailable() -> some View { focusSection() }
#endif

}
