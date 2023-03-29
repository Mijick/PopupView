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
    @State private var heights: [AnyPopup<CentrePopupConfig>: CGFloat] = [:]


    var body: some View {
        createPopup()
            .frame(width: UIScreen.width, height: UIScreen.height)
            .background(createTapArea())
            .animation(transitionAnimation, value: height)
            .transition(.asymmetric(insertion: .opacity.animation(transitionAnimation), removal: .scale(scale: 0.9).combined(with: .opacity).animation(items.count == 0 ? transitionAnimation : nil)))
            //.onChange(of: items, perform: onItemsChange)
    }
}

private extension PopupCentreStackView {
    func createPopup() -> some View {
        items.last?.body
            .readHeight { saveHeight($0, for: items.last!) }
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
            .scaleEffect(scale)
            //.opacity(opacity)
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.tapOutsideClosesView)
    }
}

// MARK: -Logic Handlers
private extension PopupCentreStackView {
    func onItemsChange(_ items: [AnyPopup<CentrePopupConfig>]) {
        //if items.isEmpty { height = nil }
    }
}

// MARK: -View Handlers
private extension PopupCentreStackView {
    func saveHeight(_ height: CGFloat, for item: AnyPopup<CentrePopupConfig>) { heights[item] = height }
}

private extension PopupCentreStackView {
    var width: CGFloat { max(0, UIScreen.width - config.horizontalPadding * 2) }
    var height: CGFloat? { heights.first { $0.key == items.last }?.value }
    var cornerRadius: CGFloat { config.cornerRadius }
    var scale: CGFloat { height == nil ? 1.1 : 1 }
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var config: CentrePopupConfig { items.last?.configurePopup(popup: .init()) ?? .init() }
}
