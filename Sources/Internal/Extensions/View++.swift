//
//  View++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Erasing with EnvironmentObject
extension View {
    func erased(with object: (any ObservableObject)?) -> AnyView {
        if let object { AnyView(environmentObject(object)) }
        else { AnyView(self) }
    }
}

// MARK: - Alignments
extension View {
    func align(to alignment: Alignment, _ value: CGFloat?) -> some View {
        padding(alignment.toEdge(), value)
            .frame(height: value != nil ? ScreenManager.shared.size.height : nil, alignment: alignment)
            .frame(maxHeight: value != nil ? .infinity : nil, alignment: alignment)
    }
}
fileprivate extension Alignment {
    func toEdge() -> Edge.Set { switch self {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        default: .init()
    }}
}

// MARK: - Actions
extension View {
    func focusSectionIfAvailable() -> some View {
    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        self
    #elseif os(tvOS)
        focusSection()
    #endif
    }
}

// MARK: - Others
extension View {
    func onChange<T: Equatable>(_ value: T, completion: @escaping (T) -> Void) -> some View {
    #if os(visionOS)
        onChange(of: value) { completion(value) }
    #else
        onChange(of: value) { _ in completion(value) }
    #endif
    }
    func overlay<V: View>(view: V) -> some View {
    #if os(visionOS)
        overlay { view }
    #else
        overlay(view)
    #endif
    }
}
