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
        .animation(stack.presenting ? globalConfig.main.animation.entry : globalConfig.main.animation.removal, value: stack.views.map(\.id))
    }
    func createOverlay() -> some View {
        overlayColour
            .ignoresSafeArea()
            .active(if: !stack.isEmpty)
            .animation(overlayAnimation, value: stack.isEmpty)
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        PopupTopStackView(items: stack.top, globalConfig: globalConfig)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: stack.centre, globalConfig: globalConfig)
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: stack.bottom, globalConfig: globalConfig)
    }
}

private extension PopupView {
    var overlayColour: Color { globalConfig.main.overlayColour }
    var overlayAnimation: Animation { .easeInOut(duration: 0.44) }
}
