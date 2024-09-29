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
            .background(getBackgroundColour(for: popup), overlayColour: .clear, corners: viewModel.calculateCornerRadius(), shadow: popupShadow)
            .opacity(viewModel.calculateOpacity(for: popup))
            .focusSectionIfAvailable()
            .padding(viewModel.calculatePopupPadding())
            .zIndex(2137)
            .compositingGroup()
    }
}

// MARK: Helpers
private extension PopupCentreStackView {
    func getTransition() -> AnyTransition {
        .scale(scale: viewModel.popups.isEmpty ? ConfigContainer.centre.transitionExitScale : ConfigContainer.centre.transitionEntryScale)
        .combined(with: .opacity)
    }
    func getBackgroundColour(for popup: AnyPopup) -> Color { popup.config.backgroundColour }
}
private extension PopupCentreStackView {
    var popupShadow: Shadow { ConfigContainer.centre.shadow }
}
