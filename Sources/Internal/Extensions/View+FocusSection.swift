//
//  View+FocusSection.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension View {
    func focusSectionIfAvailable() -> some View {
        #if os(tvOS)
            focusSection()
        #else
            self
        #endif
    }
}
