//
//  File.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

// PROBLEMY:
// 2. DISMISS NA PRZYKŁAD TOP POWODUJE DISMISS OSTATNIEGO ELEMENTU JAKO TAKIEGO A NIE TOP



public struct PopupView: View {
    let sourceView: any View
    @StateObject private var stack: PopupStackManager = .shared


    public init(@ViewBuilder _ builder: () -> some View) { self.sourceView = builder() }
    public var body: some View {
        ZStack {
            createSourceView()
            createOverlay()
            createPopupStackView()
        }
        .animation(.default, value: stack.isEmpty)
    }
}

private extension PopupView {
    func createSourceView() -> some View {
        AnyView(sourceView)
    }
    func createPopupStackView() -> some View {
        ZStack {
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
        .frame(width: UIScreen.width, height: UIScreen.height)
    }
    func createOverlay() -> some View {
        Color.black.opacity(0.44)
            .ignoresSafeArea()
            .transition(.opacity)

            .active(if: !stack.isEmpty)
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        PopupTopStackView(items: stack.top, closingAction: stack.dismiss)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: stack.centre, closingAction: stack.dismiss)
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: stack.bottom, closingAction: stack.dismiss)
    }
}

private extension PopupView {

}

private extension PopupView {

}

private extension PopupView {

}








class PopupStackManager: ObservableObject {
    @Published private var views: [any Popup] = []

    static let shared: PopupStackManager = .init()
    private init() {}
}

extension PopupStackManager {
    var top: [AnyTopPopup] { views.compactMap { $0 as? AnyTopPopup } }
    var centre: [AnyCentrePopup] { views.compactMap { $0 as? AnyCentrePopup } }
    var bottom: [AnyBottomPopup] { views.compactMap { $0 as? AnyBottomPopup } }
    var isEmpty: Bool { views.isEmpty }
}

extension PopupStackManager {
    func present(_ popup: some Popup) {
        views.append(popup, if: canBeInserted(popup))
    }
    func dismiss() {
        views.removeLast()
    }
}

extension PopupStackManager {
    func canBeInserted(_ popup: some Popup) -> Bool { !views.contains(where: { $0.id == popup.id }) }
    func canBeDismissed() -> Bool { !views.isEmpty }
}
