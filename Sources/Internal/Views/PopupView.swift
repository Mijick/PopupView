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
    @StateObject private var topStackViewModel: VM.VerticalStack<TopPopupConfig> = .init()
    @StateObject private var centreStackViewModel: VM.CentreStack = .init()
    @StateObject private var bottomStackViewModel: VM.VerticalStack<BottomPopupConfig> = .init()


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
        .onAppear() {
            updateViewModels { $0.setup(updatePopupAction: updatePopup, closePopupAction: closePopup) }
        }
        .onChange(of: popupManager.stack.map { [$0.height, $0.dragHeight] }) { _ in
            updateViewModels { $0.updatePopupsValue(popupManager.stack) }
        }
        .onChange(of: popupManager.stack) { [stack = popupManager.stack] newValue in
            newValue
                .difference(from: stack)
                .forEach { switch $0 {
                    case .remove(_, let element, _): element.onDismiss()
                    default: return
                }}
            popupManager.stack.last?.onFocus()
        }
        .onKeyboardStateChange { isActive in
            updateViewModels { $0.updateKeyboardValue(isActive) }
        }
    }
}

private extension PopupView {
    // PROBLEM: OVERLAY MA PRZYKRYWAĆ RÓWNIEŻ POZOSTAŁE WIDOKI
    // PROBLEM: CZASAMI BACKGROUND BOTTOM POPUP STACK NIE PRZYKRYWA CALOSCI
    func createPopupStackView() -> some View {
        ZStack {
            overlayColor.animation(.transition, value: popupManager.stack)
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
    }
}

private extension PopupView {
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
    func updateViewModels(_ updateBuilder: (any SomeViewModel) -> ()) {
        [topStackViewModel, centreStackViewModel, bottomStackViewModel].forEach(updateBuilder)
    }
}

private extension PopupView {
    var tapOutsideClosesPopup: Bool { popupManager.stack.last?.config.isTapOutsideToDismissEnabled ?? false }
    var overlayColor: Color { popupManager.stack.last?.config.overlayColor ?? .clear }
}
