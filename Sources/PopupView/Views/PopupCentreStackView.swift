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
    let items: [AnyCentrePopup]
    let closingAction: () -> ()
    @State private var height: CGFloat = 0

    
    var body: some View {
        createPopup()
            //.frame(width: UIScreen.width, height: UIScreen.height)
            //.background(createTapArea())
            .animation(transitionAnimation, value: height)
            .onDisappear(perform: onDisappear)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        items.last?
            .readHeight(onChange: getHeight)
            .frame(width: width, height: height == 0 ? nil : height)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
            .scaleEffect(height.isZero ? 1.3 : 1)
            .opacity(opacity)
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: closingAction)
            .active(if: config.tapOutsideClosesView)
    }
}

// MARK: -Logic Handlers
private extension PopupCentreStackView {
    func onDisappear() {
        height = 0
    }
}

// MARK: -View Handlers
private extension PopupCentreStackView {
    func getHeight(_ value: CGFloat) { height = value }
}

private extension PopupCentreStackView {
    var width: CGFloat { max(0, UIScreen.width - config.horizontalPadding * 2) }
    //var widthAnimationStartValue: CGFloat { 66 }
    var opacity: Double { (!height.isZero).doubleValue }
    var cornerRadius: CGFloat { config.cornerRadius }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var transition: AnyTransition { .asymmetric(insertion: .identity, removal: .scale) }
    var config: CentrePopupConfig { items.last?.configBuilder(.init()) ?? .init() }
}
