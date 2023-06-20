//
//  PopupView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupView: View {
    @StateObject private var stack: PopupManager = .shared
    @StateObject private var keyboardObserver: KeyboardManager = .init()
    @StateObject private var screen: ScreenManager = .init()


    var body: some View {
        createPopupStackView().background(createOverlay())
    }
}

private extension PopupView {
    func createPopupStackView() -> some View {
        ZStack {
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
    }
    func createOverlay() -> some View {
        overlayColour
            .frame(size: screen.size)
            .ignoresSafeArea()
            .visible(if: !stack.isEmpty)
            .animation(overlayAnimation, value: stack.isEmpty)
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        PopupTopStackView(items: stack.top, screen: screen)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: stack.centre, screen: screen)
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: stack.bottom, keyboardHeight: keyboardObserver.keyboardHeight, screen: screen)
    }
}

private extension PopupView {
    var overlayColour: Color { .black.opacity(0.44) }
    var overlayAnimation: Animation { .easeInOut }
}
