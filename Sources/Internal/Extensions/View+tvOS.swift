//
//  View+tvOS.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


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
