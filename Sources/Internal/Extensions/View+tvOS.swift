//
//  View+tvOS.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: Focus Section
extension View {
    func focusSection_tvOS() -> some View {
        #if os(tvOS)
        focusSection()
        #else
        self
        #endif
    }
}
