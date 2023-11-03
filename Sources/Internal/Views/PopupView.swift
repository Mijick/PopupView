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
    @ObservedObject private var screenManager: ScreenManager = .shared


    var body: some View { createBody() }
}

// MARK: - tvOS Implementation
#elseif os(tvOS)
struct PopupView: View {
    let rootView: any View
    let globalConfig: GlobalConfig
    @ObservedObject private var stack: PopupManager = .shared
    @ObservedObject private var screenManager: ScreenManager = .shared


    var body: some View {
        AnyView(rootView)
            .disabled(!stack.views.isEmpty)
            .overlay(createBody())
    }
}
#endif


// MARK: - Common Part
private extension PopupView {
    func createBody() -> some View {
        createPopupStackView()
            .frame(height: screenManager.size.height)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(createOverlay())
    }
}

private extension PopupView {
    func createPopupStackView() -> some View {
        ZStack {
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
        .animation(stackAnimation, value: stack.views.map(\.id))
    }
    func createOverlay() -> some View {
        overlayColour
            .ignoresSafeArea()
            .active(if: isOverlayActive)
            .animation(overlayAnimation, value: isStackEmpty)
            .animation(overlayAnimation, value: shouldOverlayBeHiddenForCurrentPopup)
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
    var isOverlayActive: Bool { !isStackEmpty && !shouldOverlayBeHiddenForCurrentPopup }
    var isStackEmpty: Bool { stack.views.isEmpty }
    var shouldOverlayBeHiddenForCurrentPopup: Bool { stack.popupsWithoutOverlay.contains(stack.views.last?.id ?? "") }
}

private extension PopupView {
    var stackAnimation: Animation { stack.presenting ? globalConfig.common.animation.entry : globalConfig.common.animation.removal }
    var overlayColour: Color { globalConfig.common.overlayColour }
    var overlayAnimation: Animation { .easeInOut(duration: 0.44) }
}
