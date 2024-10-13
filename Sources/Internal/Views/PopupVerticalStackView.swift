//
//  PopupVerticalStackView.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupVerticalStackView<Config: LocalConfig.Vertical>: View {
    @ObservedObject var viewModel: VM.VerticalStack<Config>


    var body: some View {
        ZStack(alignment: (!viewModel.alignment).toAlignment(), content: createPopupStack)
            .frame(height: viewModel.screen.height, alignment: viewModel.alignment.toAlignment())
            .onDragGesture(onChanged: viewModel.onPopupDragGestureChanged, onEnded: viewModel.onPopupDragGestureEnded)
    }
}
private extension PopupVerticalStackView {
    func createPopupStack() -> some View {
        ForEach(viewModel.popups, id: \.self, content: createPopup)
    }
}
private extension PopupVerticalStackView {
    func createPopup(_ popup: AnyPopup) -> some View {
        popup.body
            .padding(viewModel.calculateBodyPadding(for: popup))
            .fixedSize(horizontal: false, vertical: viewModel.calculateVerticalFixedSize(for: popup))
            .onHeightChange { viewModel.recalculateAndSave(height: $0, for: popup) }
            .frame(height: viewModel.activePopupHeight, alignment: (!viewModel.alignment).toAlignment())
            .frame(maxWidth: .infinity, maxHeight: viewModel.activePopupHeight, alignment: (!viewModel.alignment).toAlignment())
            .background(backgroundColor: getBackgroundColor(for: popup), overlayColor: getStackOverlayColor(for: popup), corners: viewModel.calculateCornerRadius())
            .offset(y: viewModel.calculateOffsetY(for: popup))
            .scaleEffect(x: viewModel.calculateScaleX(for: popup))
            .focusSectionIfAvailable()
            .padding(viewModel.calculatePopupPadding())
            .transition(transition)
            .zIndex(viewModel.calculateZIndex(for: popup))
            .compositingGroup()
    }
}

private extension PopupVerticalStackView {
    func getBackgroundColor(for popup: AnyPopup) -> Color { popup.config.backgroundColor }
    func getStackOverlayColor(for popup: AnyPopup) -> Color { stackOverlayColor.opacity(viewModel.calculateStackOverlayOpacity(for: popup)) }
}
private extension PopupVerticalStackView {
    var stackOverlayColor: Color { .black }
    var transition: AnyTransition { .move(edge: viewModel.alignment.toEdge()) }
}
