//
//  PopupView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - iOS / macOS Implementation
#if os(iOS) || os(macOS)
struct PopupView: View {
    let globalConfig: GlobalConfig
    @ObservedObject private var stack: PopupManager = .shared
    @StateObject private var keyboardObserver: KeyboardManager = .init()


    var body: some View {
        createPopupStackView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(createOverlay())
    }
}

// MARK: - tvOS Implementation
#elseif os(tvOS)
struct PopupView: View {
    let rootView: any View
    let globalConfig: GlobalConfig
    @ObservedObject private var stack: PopupManager = .shared
    @StateObject private var keyboardObserver: KeyboardManager = .init()


    var body: some View {
        AnyView(rootView)
            .disabled(!stack.views.isEmpty)
            .overlay(createBody())
    }
}
private extension PopupView {
    func createBody() -> some View {
        createPopupStackView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(createOverlay())
    }
}
#endif


// MARK: - Common Part
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
            .ignoresSafeArea()
            .visible(if: !stack.isEmpty)
            .animation(overlayAnimation, value: stack.isEmpty)
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        PopupTopStackView(items: stack.top, globalConfig: globalConfig.top)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: stack.centre, globalConfig: globalConfig.centre)
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: stack.bottom, keyboardHeight: keyboardObserver.keyboardHeight, globalConfig: globalConfig.bottom)
    }
}

private extension PopupView {
    var overlayColour: Color { .black.opacity(0.44) }
    var overlayAnimation: Animation { .easeInOut }
}
