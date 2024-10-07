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
    @ObservedObject var viewModel: VM.CentreStack

    
    var body: some View {
        ZStack(content: createPopupStack)
            .id(viewModel.popups.isEmpty)
            .transition(getTransition())
            .frame(maxWidth: .infinity, maxHeight: viewModel.screen.height)
            .zIndex(viewModel.calculateZIndex(for: viewModel.popups.last))
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
            .fixedSize(horizontal: false, vertical: viewModel.calculateVerticalFixedSize(for: popup))
            .onHeightChange { viewModel.recalculateAndSave(height: $0, for: popup) }
            .frame(height: viewModel.activePopupHeight)
            .frame(maxWidth: .infinity, maxHeight: viewModel.activePopupHeight)
            .background(getBackgroundColor(for: popup), overlayColor: .clear, corners: viewModel.calculateCornerRadius(), shadow: popupShadow)
            .opacity(viewModel.calculateOpacity(for: popup))
            .focusSectionIfAvailable()
            .padding(viewModel.calculatePopupPadding())
            .compositingGroup()
    }
}

// MARK: Helpers
private extension PopupCentreStackView {
    func getTransition() -> AnyTransition {
        .scale(scale: transitionScale)
        .combined(with: .opacity)
    }
    func getBackgroundColor(for popup: AnyPopup) -> Color { popup.config.backgroundColor }
}
private extension PopupCentreStackView {
    var popupShadow: Shadow { ConfigContainer.centre.shadow }
    var transitionScale: CGFloat { 1.12 }
}
