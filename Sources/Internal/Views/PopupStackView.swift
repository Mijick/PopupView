//
//  PopupStackView.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

struct PopupStackView<Config: LocalConfig.Vertical>: View {
    @ObservedObject var viewModel: ViewModel


    var body: some View {
        ZStack(alignment: (!viewModel.alignment).toAlignment(), content: createPopupStack)
            .frame(height: viewModel.screen.height, alignment: viewModel.alignment.toAlignment())
            .onDragGesture(onChanged: viewModel.onPopupDragGestureChanged, onEnded: viewModel.onPopupDragGestureEnded)
    }
}
private extension PopupStackView {
    func createPopupStack() -> some View {
        ForEach(viewModel.popups, id: \.self, content: createPopup)
    }
}
private extension PopupStackView {
    func createPopup(_ popup: AnyPopup) -> some View { let config = viewModel.getConfig(popup)
        return popup.body
            .padding(viewModel.calculateBodyPadding(popupConfig: config))
            .fixedSize(horizontal: false, vertical: viewModel.calculateVerticalFixedSize(popupConfig: config))
            .onHeightChange { viewModel.save(height: $0, for: popup) }
            .frame(height: viewModel.activePopupHeight, alignment: (!viewModel.alignment).toAlignment())
            .frame(maxWidth: .infinity, maxHeight: viewModel.activePopupHeight, alignment: (!viewModel.alignment).toAlignment())
            .background(getBackgroundColour(popupConfig: config), overlayColour: getStackOverlayColour(for: popup), corners: viewModel.calculateCornerRadius(), shadow: popupShadow)
            .offset(y: viewModel.calculateOffsetY(for: popup))
            .scaleEffect(x: viewModel.calculateScaleX(for: popup))
            .focusSectionIfAvailable()
            .padding(viewModel.calculatePopupPadding())
            .transition(transition)
            .zIndex(viewModel.calculateZIndex(for: popup))
            .compositingGroup()
    }
}

// MARK: Helpers
private extension PopupStackView {
    func getBackgroundColour(popupConfig: Config) -> Color { popupConfig.backgroundColour }
    func getStackOverlayColour(for popup: AnyPopup) -> Color { stackOverlayColour.opacity(viewModel.calculateStackOverlayOpacity(for: popup)) }
}
private extension PopupStackView {
    var popupShadow: Shadow { ConfigContainer.vertical.shadow }
    var stackOverlayColour: Color { .black }
    var transition: AnyTransition { .move(edge: viewModel.alignment.toEdge()) }
}
