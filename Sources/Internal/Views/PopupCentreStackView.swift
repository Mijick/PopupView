//
//  PopupCentreStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupCentreStackView: PopupStack { typealias Config = CentrePopupConfig
    @Binding var items: [AnyPopup]
    let globalConfig: GlobalConfig
    @ObservedObject private var screen: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared
    @State private var height: CGFloat?
    @State private var contentIsAnimated: Bool = false

    
    var body: some View {
        createPopup()
            .align(to: .bottom, keyboardManager.height == 0 ? nil : keyboardManager.height)
            .transition(getTransition())
            .frame(maxWidth: .infinity, maxHeight: screen.size.height)
            .background(createTapArea())
            .animation(.transition, value: lastPopupConfig.horizontalPadding)
            .animation(.transition, value: height)
            .animation(.transition, value: contentIsAnimated)
            .animation(.keyboard, value: keyboardManager.height)
            .onChange(of: items, perform: onItemsChange)
    }
}
private extension PopupCentreStackView {
    func createPopup() -> some View {
        items.last?.body
            .readHeight(onChange: saveHeight)
            .frame(height: height).frame(maxWidth: .infinity, maxHeight: height)
            .opacity(contentOpacity)
            .background(backgroundColour, overlayColour: .clear, radius: cornerRadius, corners: .allCorners, shadow: popupShadow)
            .padding(.horizontal, lastPopupConfig.horizontalPadding)
            .compositingGroup()
            .focusSectionIfAvailable()
            .id(items.isEmpty)
    }
}

// MARK: - Logic Modifiers
private extension PopupCentreStackView {
    func onItemsChange(_ items: [AnyPopup]) {
        guard let popup = items.last else { return handleClosingPopup() }

        animateContentIfNeeded()
    }
}
private extension PopupCentreStackView {
    func animateContentIfNeeded() { if height != nil {
        contentIsAnimated = true
        DispatchQueue.main.asyncAfter(deadline: .now() + contentOpacityAnimationTime) { contentIsAnimated = false }
    }}
    func handleClosingPopup() { DispatchQueue.main.async {
        height = nil
    }}
}

// MARK: - View Modifiers
private extension PopupCentreStackView {
    func saveHeight(_ value: CGFloat) { DispatchQueue.main.async { height = items.isEmpty ? nil : value } }
    func getTransition() -> AnyTransition {
        .scale(scale: items.isEmpty ? globalConfig.centre.transitionExitScale : globalConfig.centre.transitionEntryScale)
        .combined(with: .opacity)
        .animation(height == nil || items.isEmpty ? .transition : nil)
    }
}

// MARK: - Flags & Values
extension PopupCentreStackView {
    var cornerRadius: CGFloat { lastPopupConfig.cornerRadius ?? globalConfig.centre.cornerRadius }
    var contentOpacity: CGFloat { contentIsAnimated ? 0 : 1 }
    var popupShadow: Shadow { globalConfig.centre.shadow }
    var contentOpacityAnimationTime: CGFloat { globalConfig.centre.contentAnimationTime }
    var backgroundColour: Color { lastPopupConfig.backgroundColour ?? globalConfig.centre.backgroundColour }

    var tapOutsideClosesPopup: Bool { lastPopupConfig.tapOutsideClosesView ?? globalConfig.bottom.tapOutsideClosesView }
}
