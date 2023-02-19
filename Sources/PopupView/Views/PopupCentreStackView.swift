//
//  PopupCentreStackView.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public extension PopupCentreStackView {
    struct Config {
        public var tapOutsideClosesView: Bool = true

        public var horizontalPadding: CGFloat = 12
        public var cornerRadius: CGFloat = 32

        public var viewOverlayColour: Color = .black.opacity(0.6)
        public var backgroundColour: Color = .white

        public var transitionAnimation: Animation { .spring(response: 0.34, dampingFraction: 1, blendDuration: 0.28) }
    }
}


public struct PopupCentreStackView: View {
    let items: [AnyPopup]
    let closingAction: () -> ()
    var config: Config = .init()
    @State private var height: CGFloat = 0


    public init(items: [AnyPopup], closingAction: @escaping () -> (), configBuilder: (inout Config) -> ()) {
        self.items = items
        self.closingAction = closingAction
        configBuilder(&config)
    }
    public var body: some View {
        createPopup()
            .frame(width: UIScreen.width, height: UIScreen.height)
            .background(createViewOverlay())
            .animation(transitionAnimation, value: height)
            .onDisappear(perform: onDisappear)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        items.last?.view
            .readHeight(onChange: getHeight)
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
            .opacity(opacity)
    }
    func createViewOverlay() -> some View {
        viewOverlayColour
            .transition(.opacity)
            .ignoresSafeArea()
            .onTapGesture(perform: onOverlayTap)
    }
}

private extension PopupCentreStackView {
    func onDisappear() {
        height = 0
    }
    func onOverlayTap() {
        if config.tapOutsideClosesView { closingAction() }
    }
}

private extension PopupCentreStackView {
    func getHeight(_ value: CGFloat) { height = value }
}

private extension PopupCentreStackView {
    var width: CGFloat { max(0, UIScreen.width - config.horizontalPadding * 2 - widthAnimationStartValue * 2 * height.isZero.floatValue) }
    var widthAnimationStartValue: CGFloat { 66 }
    var opacity: Double { (!height.isZero).doubleValue }
    var cornerRadius: CGFloat { config.cornerRadius }
    var viewOverlayColour: Color { config.viewOverlayColour }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var transition: AnyTransition { .asymmetric(insertion: .identity, removal: .scale) }
}
