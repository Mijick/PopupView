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
    let items: [AnyPopup<CentrePopupConfig>]
    @State private var height: CGFloat = 0

    
    var body: some View {
        Group {
            if items.isEmpty { EmptyView() }
            else { createPopup() }
        }
        //.id(items.isEmpty)
        //.animation(transitionAnimation, value: items)
        .transition(
            .asymmetric(insertion: .move(edge: .leading).animation(transitionAnimation),//.scale(scale: 1.1).combined(with: .opacity).animation(transitionAnimation),

                        removal: .scale(scale: 0.9).combined(with: .opacity).animation(transitionAnimation))
        )



            //.scale(scale: 1.12).combined(with: .opacity).animation(transitionAnimation))
        .frame(width: UIScreen.width, height: UIScreen.height)
        .background(createTapArea())
        .animation(transitionAnimation, value: height)







            //.onChange(of: items, perform: onItemsChange)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        items.last?.body
            .readHeight(onChange: getHeight)
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
            //.scaleEffect(scale)
            //.opacity(opacity)
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.tapOutsideClosesView)
    }
}

// MARK: -View Handlers
private extension PopupCentreStackView {
    func getHeight(_ value: CGFloat) { height = value }
}

private extension PopupCentreStackView {
    var width: CGFloat { max(0, UIScreen.width - config.horizontalPadding * 2) }
    var cornerRadius: CGFloat { config.cornerRadius }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var config: CentrePopupConfig { items.last?.configurePopup(popup: .init()) ?? .init() }
}
