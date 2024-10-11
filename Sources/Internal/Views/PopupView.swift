//
//  PopupView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - iOS / macOS Implementation
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
struct PopupView: View {
    @ObservedObject var popupManager: PopupManager
    private let topStackViewModel: VM.VerticalStack<TopPopupConfig> = .init()
    private let centreStackViewModel: VM.CentreStack = .init()
    private let bottomStackViewModel: VM.VerticalStack<BottomPopupConfig> = .init()


    var body: some View { createBody() }
}

// MARK: - tvOS Implementation
#elseif os(tvOS)
struct PopupView: View {
    let rootView: any View
    @ObservedObject private var popupManager: PopupManager = .shared


    var body: some View {
        AnyView(rootView)
            .disabled(!popupManager.views.isEmpty)
            .overlay(createBody())
    }
}
#endif


// MARK: - Common Part
private extension PopupView {
    func createBody() -> some View {
        GeometryReader { reader in
            createPopupStackView()
                .ignoresSafeArea()
                .onAppear { updateScreenValue(reader) }
                .onChange(of: reader.size) { _ in updateScreenValue(reader) }
        }
        .onTapGesture(perform: onTap)
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
        overlayColor.animation(.linear, value: popupManager.stack.isEmpty)
    }
    func createTopPopupStackView() -> some View {
        PopupVerticalStackView(viewModel: topStackViewModel)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(viewModel: centreStackViewModel)
    }
    func createBottomPopupStackView() -> some View {
        PopupVerticalStackView(viewModel: bottomStackViewModel)
    }
}

private extension PopupView {
    func onAppear() {
        updateViewModels { $0.setup(updatePopupAction: updatePopup, closePopupAction: closePopup) }
    }
    func onKeyboardStateChange(_ isKeyboardActive: Bool) {
        updateViewModels { $0.updateKeyboardValue(isKeyboardActive) }
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
    func updateScreenValue(_ reader: GeometryProxy) {
        updateViewModels { $0.updateScreenValue(.init(reader)) }
    }



    func updatePopup(_ popup: AnyPopup) {
        popupManager.updateStack(popup)
    }
    func closePopup(_ popup: AnyPopup) {
        popupManager.stack(.removePopupInstance(popup))
    }
    func onTap() { if tapOutsideClosesPopup {
        popupManager.stack(.removeLastPopup)
    }}
}
private extension PopupView {
    func updateViewModels(_ updateBuilder: (any ViewModelObject) -> ()) {
        [topStackViewModel, centreStackViewModel, bottomStackViewModel].forEach(updateBuilder)
    }
}

private extension PopupView {
    var tapOutsideClosesPopup: Bool { popupManager.stack.last?.config.isTapOutsideToDismissEnabled ?? false }
    var overlayColor: Color { popupManager.stack.last?.config.overlayColor ?? .clear }
}
