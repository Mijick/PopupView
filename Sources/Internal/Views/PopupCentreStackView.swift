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
            .transition(transition)
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
            .fixedSize(horizontal: false, vertical: viewModel.calculateVerticalFixedSize(for: popup))
            .onHeightChange { viewModel.recalculateAndSave(height: $0, for: popup) }
            .frame(height: viewModel.activePopupHeight)
            .frame(maxWidth: .infinity, maxHeight: viewModel.activePopupHeight)
            .background(backgroundColor: getBackgroundColor(for: popup), overlayColor: .clear, corners: viewModel.calculateCornerRadius())
            .opacity(viewModel.calculateOpacity(for: popup))
            .focusSectionIfAvailable()
            .padding(viewModel.calculatePopupPadding())
            .compositingGroup()
    }
}

private extension PopupCentreStackView {
    func getBackgroundColor(for popup: AnyPopup) -> Color { popup.config.backgroundColor }
}
private extension PopupCentreStackView {
    var transition: AnyTransition { .scale(scale: 1.1).combined(with: .opacity) }
}
