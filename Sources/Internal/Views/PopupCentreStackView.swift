//
//  PopupCentreStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupCentreStackView: View {
    @ObservedObject var viewModel: ViewModel

    
    var body: some View {
        ZStack(content: createPopupStack)
            .id(viewModel.popups.isEmpty)
            .transition(getTransition())
            .frame(maxWidth: .infinity, maxHeight: viewModel.screen.height)
    }
}
private extension PopupCentreStackView {
    func createPopupStack() -> some View {
        ForEach(viewModel.popups, id: \.self, content: createPopup)
    }
}
private extension PopupCentreStackView {
    func createPopup(_ popup: AnyPopup) -> some View {
        popup.body
            .onHeightChange { viewModel.recalculateAndSave(height: $0, for: popup) }
            .frame(height: viewModel.activePopupHeight)
            .frame(maxWidth: .infinity, maxHeight: viewModel.activePopupHeight)
            .background(backgroundColour, overlayColour: .clear, corners: [.top: cornerRadius, .bottom: cornerRadius], shadow: popupShadow)
            .padding(.horizontal, config.horizontalPadding)
            .opacity(getOpacity(popup))
            .compositingGroup()
            .focusSectionIfAvailable()
            .padding(.bottom, viewModel.isKeyboardActive ? viewModel.screen.safeArea.bottom : nil)
            .zIndex(2137)
    }
}

// MARK: - View Modifiers
private extension PopupCentreStackView {
    func saveHeight(_ newHeight: CGFloat, _ item: Binding<AnyPopup>) { if item.wrappedValue.height != newHeight { Task { @MainActor in
        item.wrappedValue.height = newHeight
    }}}
    func getOpacity(_ popup: AnyPopup) -> CGFloat {
        viewModel.popups.last == popup ? 1 : 0
    }
    func getTransition() -> AnyTransition {
        .scale(scale: viewModel.popups.isEmpty ? ConfigContainer.centre.transitionExitScale : ConfigContainer.centre.transitionEntryScale)
        .combined(with: .opacity)
    }
}

// MARK: - Flags & Values
extension PopupCentreStackView {
    var cornerRadius: CGFloat { config.cornerRadius }
    var popupShadow: Shadow { ConfigContainer.centre.shadow }
    var backgroundColour: Color { config.backgroundColour }
    var config: CentrePopupConfig { (viewModel.popups.last?.config as? CentrePopupConfig) ?? .init() }
}
