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
        ForEach(viewModel.items, id: \.self, content: createPopup)
    }
}
private extension PopupStackView {
    func createPopup(_ item: AnyPopup) -> some View { let config = viewModel.getConfig(item)
        return item.body
            .padding(viewModel.calculateBodyPadding(popupConfig: config))
            .fixedSize(horizontal: false, vertical: viewModel.calculateVerticalFixedSize(popupConfig: config))
            .onHeightChange { viewModel.save(height: $0, for: item, popupConfig: config) }
            .frame(height: viewModel.activePopupHeight, alignment: (!viewModel.alignment).toAlignment())
            .frame(maxWidth: .infinity, maxHeight: viewModel.activePopupHeight, alignment: (!viewModel.alignment).toAlignment())
            .background(viewModel.getBackgroundColour(popupConfig: config), overlayColour: viewModel.getStackOverlayColour(for: item), corners: viewModel.calculateCornerRadius(), shadow: viewModel.popupShadow)
            .offset(y: viewModel.calculateOffset(for: item))
            .scaleEffect(x: viewModel.calculateScale(for: item))
            .focusSectionIfAvailable()
            .padding(viewModel.calculatePopupPadding())
            .transition(viewModel.transition)
            .zIndex(viewModel.calculateZIndex(for: item))
            .compositingGroup()
    }
}


