//
//  View++.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

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
