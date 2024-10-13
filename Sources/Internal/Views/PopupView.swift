//
//  PopupView.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2023 Mijick. All rights reserved.


import SwiftUI

struct PopupView: View {
    #if os(tvOS)
    let rootView: any View
    #endif

    @ObservedObject var popupManager: PopupManager
    private let topStackViewModel: VM.VerticalStack<TopPopupConfig> = .init()
    private let centreStackViewModel: VM.CentreStack = .init()
    private let bottomStackViewModel: VM.VerticalStack<BottomPopupConfig> = .init()


    var body: some View {
        #if os(tvOS)
        AnyView(rootView)
            .disabled(!popupManager.stack.isEmpty)
            .overlay(createBody())
        #else
        createBody()
        #endif
    }
}
private extension PopupView {
    func createBody() -> some View {
        GeometryReader { reader in
            createPopupStackView()
                .ignoresSafeArea()
                .onAppear { onScreenChange(reader) }
                .onChange(of: reader.size) { _ in onScreenChange(reader) }
        }
        .onAppear(perform: onAppear)
        .onChange(of: popupManager.stack.map { [$0.height, $0.dragHeight] }, perform: onPopupsHeightChange)
        .onChange(of: popupManager.stack) { [oldValue = popupManager.stack] newValue in onStackChange(oldValue, newValue) }
        .onKeyboardStateChange(perform: onKeyboardStateChange)
    }
}
private extension PopupView {
    func createPopupStackView() -> some View {
        ZStack {
            createOverlayView()
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
    }
}
private extension PopupView {
    func createOverlayView() -> some View {
        getOverlayColor()
            .zIndex(popupManager.stackPriority.overlay)
            .animation(.linear, value: popupManager.stack)
            .onTapGesture(perform: onTap)
    }
    func createTopPopupStackView() -> some View {
        PopupVerticalStackView(viewModel: topStackViewModel).zIndex(popupManager.stackPriority.top)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(viewModel: centreStackViewModel).zIndex(popupManager.stackPriority.centre)
    }
    func createBottomPopupStackView() -> some View {
        PopupVerticalStackView(viewModel: bottomStackViewModel).zIndex(popupManager.stackPriority.bottom)
    }
}
private extension PopupView {
    func getOverlayColor() -> Color { switch popupManager.stack.last?.config.overlayColor {
        case .some(let color) where color == .clear: .black.opacity(0.0000000000001)
        case .some(let color): color
        case nil: .clear
    }}
}

private extension PopupView {
    func onAppear() {
        updateViewModels { $0.setup(updatePopupAction: updatePopup, closePopupAction: closePopup) }
    }
    func onScreenChange(_ reader: GeometryProxy) {
        updateViewModels { $0.updateScreenValue(.init(reader)) }
    }
    func onPopupsHeightChange(_ p: Any) {
        updateViewModels { $0.updatePopupsValue(popupManager.stack) }
    }
    func onStackChange(_ oldStack: [AnyPopup], _ newStack: [AnyPopup]) {
        newStack
            .difference(from: oldStack)
            .forEach { switch $0 {
                case .remove(_, let element, _): element.onDismiss()
                default: return
            }}
        newStack.last?.onFocus()
    }
    func onKeyboardStateChange(_ isKeyboardActive: Bool) {
        updateViewModels { $0.updateKeyboardValue(isKeyboardActive) }
    }
    func onTap() { if tapOutsideClosesPopup {
        popupManager.stack(.removeLastPopup)
    }}
}
private extension PopupView {
    func updatePopup(_ popup: AnyPopup) {
        popupManager.updateStack(popup)
    }
    func closePopup(_ popup: AnyPopup) {
        popupManager.stack(.removePopupInstance(popup))
    }
    func updateViewModels(_ updateBuilder: (any ViewModelObject) -> ()) {
        [topStackViewModel, centreStackViewModel, bottomStackViewModel].forEach(updateBuilder)
    }
}
private extension PopupView {
    var tapOutsideClosesPopup: Bool { popupManager.stack.last?.config.isTapOutsideToDismissEnabled ?? false }
}
