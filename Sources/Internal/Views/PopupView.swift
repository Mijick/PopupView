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
    @ObservedObject private var keyboardManager: KeyboardManager = .shared
    @StateObject private var topStackViewModel: VM.VerticalStack<TopPopupConfig> = .init()
    @StateObject private var centreStackViewModel: VM.CentreStack = .init()
    @StateObject private var bottomStackViewModel: VM.VerticalStack<BottomPopupConfig> = .init()


    var body: some View { createBody() }
}

// MARK: - tvOS Implementation
#elseif os(tvOS)
struct PopupView: View {
    let rootView: any View
    @State private var zIndex: ZIndex = .init()
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
                .onAppear {
                    let screen = ScreenProperties()
                    screen.update(reader)
                    topStackViewModel.updateScreenValue(screen)
                    centreStackViewModel.updateScreenValue(screen)
                    bottomStackViewModel.updateScreenValue(screen)


                }
                .onChange(of: reader.size) { _ in
                    let screen = ScreenProperties()
                    screen.update(reader)
                    topStackViewModel.updateScreenValue(screen)
                    centreStackViewModel.updateScreenValue(screen)
                    bottomStackViewModel.updateScreenValue(screen)


                }
        }




            .animation(.transition, value: popupManager.views)
            .onTapGesture(perform: onTap)
            .onAppear() {
                topStackViewModel.setup(updatePopupAction: updatePopup, closePopupAction: closePopup)
                centreStackViewModel.setup(updatePopupAction: updatePopup, closePopupAction: closePopup)
                bottomStackViewModel.setup(updatePopupAction: updatePopup, closePopupAction: closePopup)
            }
            .onChange(of: popupManager.views.map { [$0.height, $0.dragHeight] }) { _ in
                topStackViewModel.updatePopupsValue(popupManager.views)
                centreStackViewModel.updatePopupsValue(popupManager.views)
                bottomStackViewModel.updatePopupsValue(popupManager.views)
            }
            .onChange(of: keyboardManager.isActive) { _ in
                topStackViewModel.updateKeyboardValue(keyboardManager.isActive)
                centreStackViewModel.updateKeyboardValue(keyboardManager.isActive)
                bottomStackViewModel.updateKeyboardValue(keyboardManager.isActive)
            }
            .onChange(of: popupManager.views) { [views = popupManager.views] newValue in
                newValue
                    .difference(from: views)
                    .forEach { switch $0 {
                        case .remove(_, let element, _): element.onDismiss()
                        default: return
                    }}
                popupManager.views.last?.onFocus()
            }
    }
}

private extension PopupView {
    // PROBLEM: OVERLAY MA PRZYKRYWAĆ RÓWNIEŻ POZOSTAŁE WIDOKI
    // PROBLEM: CZASAMI BACKGROUND BOTTOM POPUP STACK NIE PRZYKRYWA CALOSCI
    func createPopupStackView() -> some View {
        ZStack {
            overlayColour
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
    func updatePopup(_ popup: AnyPopup) {
        popupManager.updateStack(popup)
    }
    func closePopup(_ popup: AnyPopup) {
        popupManager.performOperation(.removeExact(popup.id))
    }
    func onTap() { if tapOutsideClosesPopup {
        PopupManager.dismiss()
    }}
}

private extension PopupView {
    var tapOutsideClosesPopup: Bool { popupManager.views.last?.config.tapOutsideClosesView ?? false }
    var overlayColour: Color { popupManager.views.last?.config.overlayColour ?? .clear }
}
