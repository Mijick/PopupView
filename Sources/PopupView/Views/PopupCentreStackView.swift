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
    @State private var height: CGFloat?

    
    var body: some View {
        ZStack {
            createTapArea()
            createPopup()
        }
        .animation(transitionAnimation, value: height)
        .onChange(of: items, perform: onItemsChange)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        items.last?
            .readHeight(onChange: getHeight)
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
            .scaleEffect(height == nil ? 1.4 : 1)
            .opacity(opacity)
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .frame(width: UIScreen.width, height: UIScreen.height)
            .onTapGesture(perform: closingAction)
            .active(if: config.tapOutsideClosesView && !items.isEmpty)
    }
}

// MARK: -Logic Handlers
private extension PopupCentreStackView {
    func onItemsChange(_ items: [AnyCentrePopup]) {
        if items.isEmpty { height = nil }
    }
}

// MARK: -View Handlers
private extension PopupCentreStackView {
    func getHeight(_ value: CGFloat) { height = value }
}

private extension PopupCentreStackView {
    var width: CGFloat { max(0, UIScreen.width - config.horizontalPadding * 2) }
    //var widthAnimationStartValue: CGFloat { 66 }
    var opacity: Double { (height != nil).doubleValue }
    var cornerRadius: CGFloat { config.cornerRadius }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var transition: AnyTransition { .asymmetric(insertion: .identity, removal: .scale) }
    var config: CentrePopupConfig { items.last?.configBuilder(.init()) ?? .init() }
}
