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



struct PopupView: View {
    @StateObject private var stack: PopupStackManager = .shared


    var body: some View {
        createPopupStackView()
            .frame(width: UIScreen.width, height: UIScreen.height)
            .background(createOverlay())
    }
}

private extension PopupView {
    func createPopupStackView() -> some View {
        ZStack {
            createTopPopupStackView()
            createCentrePopupStackView()
            createBottomPopupStackView()
        }
    }
    func createOverlay() -> some View {
        overlayColour
            .ignoresSafeArea()
            .visible(if: !stack.isEmpty)
            .animation(overlayAnimation, value: stack.isEmpty)
    }
}

private extension PopupView {
    func createTopPopupStackView() -> some View {
        PopupTopStackView(items: stack.top)
    }
    func createCentrePopupStackView() -> some View {
        PopupCentreStackView(items: stack.centre)
    }
    func createBottomPopupStackView() -> some View {
        PopupBottomStackView(items: stack.bottom)
    }
}

private extension PopupView {
    var overlayColour: Color { .black.opacity(0.44) }
    var overlayAnimation: Animation { .easeInOut }
}




// dismiss w:
// 1. Globalnie - dismiss(all, id, last)
