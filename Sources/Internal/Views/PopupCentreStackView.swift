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
    @ObservedObject private var screen: ScreenManager = .shared
    @ObservedObject private var keyboardManager: KeyboardManager = .shared

    
    var body: some View {
        ZStack(content: createPopupStack)
            .id(items.isEmpty)
            .transition(getTransition())
            .frame(maxWidth: .infinity, maxHeight: screen.size.height)
            .animation(.transition, value: config.horizontalPadding)
            .animation(.transition, value: items)
            .animation(.transition, value: items.last?.height)
            .animation(.keyboard, value: keyboardManager.height)
    }
}
private extension PopupCentreStackView {
    func createPopupStack() -> some View {
        ForEach($items, id: \.self, content: createPopup)
    }
}
private extension PopupCentreStackView {
    func createPopup(_ item: Binding<AnyPopup>) -> some View {
        item.wrappedValue.body
            .onHeightChange { saveHeight($0, item) }
            .frame(height: getHeight()).frame(maxWidth: .infinity, maxHeight: getHeight())
            .background(backgroundColour, overlayColour: .clear, radius: cornerRadius, corners: .allCorners, shadow: popupShadow)
            .padding(.horizontal, config.horizontalPadding)
            .opacity(getOpacity(item))
            .compositingGroup()
            .focusSectionIfAvailable()
            .align(to: .bottom, keyboardManager.height == 0 ? nil : keyboardManager.height)
            .zIndex(2137)
    }
}

// MARK: - View Modifiers
private extension PopupCentreStackView {
    func saveHeight(_ newHeight: CGFloat, _ item: Binding<AnyPopup>) { if item.wrappedValue.height != newHeight { Task { @MainActor in
        item.wrappedValue.height = newHeight
    }}}
    func getOpacity(_ item: Binding<AnyPopup>) -> CGFloat {
        items.last == item.wrappedValue ? 1 : 0
    }
    func getHeight() -> CGFloat { switch items.last?.height {
        case 0: getInitialHeight()
        default: items.last?.height ?? 0
    }}
    func getTransition() -> AnyTransition {
        .scale(scale: items.isEmpty ? ConfigContainer.centre.transitionExitScale : ConfigContainer.centre.transitionEntryScale)
        .combined(with: .opacity)
    }
}

// MARK: - Flags & Values
extension PopupCentreStackView {
    var cornerRadius: CGFloat { config.cornerRadius }
    var popupShadow: Shadow { ConfigContainer.centre.shadow }
    var backgroundColour: Color { config.backgroundColour }
    var config: Config { items.last.getConfig() }
}
