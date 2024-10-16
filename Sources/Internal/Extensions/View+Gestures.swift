//
//  View+Gestures.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


import SwiftUI

// MARK: On Tap Gesture
extension View {
    func onTapGesture(perform action: @escaping () -> ()) -> some View {
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        onTapGesture(count: 1, perform: action)
        #elseif os(tvOS)
        self
        #endif
    }
}

// MARK: On Drag Gesture
extension View {
    func onDragGesture(onChanged actionOnChanged: @escaping (CGFloat) -> (), onEnded actionOnEnded: @escaping (CGFloat) -> ()) -> some View {
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        highPriorityGesture(DragGesture()
            .onChanged { actionOnChanged($0.translation.height) }
            .onEnded { actionOnEnded($0.translation.height) }
        )
        #elseif os(tvOS)
        self
        #endif
    }
}
