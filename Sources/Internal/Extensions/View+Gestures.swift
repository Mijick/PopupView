//
//  View+Gestures.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


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
    
}



// MARK: - iOS + macOS Implementation
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
extension View {
    func onDragGesture(onChanged actionOnChanged: @escaping (CGFloat) -> (), onEnded actionOnEnded: @escaping (CGFloat) -> ()) -> some View { highPriorityGesture(createDragGesture(actionOnChanged, actionOnEnded)) }
}
private extension View {
    func createDragGesture(_ actionOnChanged: @escaping (CGFloat) -> (), _ actionOnEnded: @escaping (CGFloat) -> ()) -> some Gesture {
        DragGesture()
            .onChanged { actionOnChanged($0.translation.height) }
            .onEnded { actionOnEnded($0.translation.height) }
    }
}


// MARK: - tvOS Implementation
#elseif os(tvOS)
extension View {
    func onDragGesture(_ state: GestureState<Bool>, onChanged actionOnChanged: @escaping (CGFloat) -> (), onEnded actionOnEnded: @escaping (CGFloat) -> ()) -> some View { self }
}
#endif
