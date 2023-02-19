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
        public var tapOutsideClosesView: Bool = false
        
        public var horizontalPadding: CGFloat = 0
        public var cornerRadius: CGFloat = 32
        
        public var viewOverlayColour: Color = .black.opacity(0.6)
        public var backgroundColour: Color = .white
        
        public var transitionAnimation: Animation { .spring(response: 0.44, dampingFraction: 1, blendDuration: 0.4) }
    }
}


public struct PopupCentreStackView: View {
    let item: AnyPopup
    let closingAction: () -> ()
    var config: Config = .init()
    

    public init(item: AnyPopup, closingAction: @escaping () -> (), configBuilder: (inout Config) -> ()) {
        self.item = item
        self.closingAction = closingAction
        configBuilder(&config)
    }
    public var body: some View {
        item.view
            .frame(width: width)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
            .transition(transition)
            .overlay(createViewOverlay())
            .zIndex(1)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        item.view
            .frame(width: width)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
            .transition(transition)
            .zIndex(1)
    }
    func createViewOverlay() -> some View {
        viewOverlayColour
    }

}

private extension PopupCentreStackView {
    var width: CGFloat { UIScreen.width - config.horizontalPadding * 2 }
    var cornerRadius: CGFloat { config.cornerRadius }
    var viewOverlayColour: Color { config.viewOverlayColour }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var transition: AnyTransition { .scale(scale: 0.6).combined(with: .opacity) }
}
