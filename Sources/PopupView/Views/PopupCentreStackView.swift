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
        a()
        .animation(transitionAnimation, value: height)
        .animation(transitionAnimation, value: items.isEmpty)
        .transition(
            .asymmetric(insertion: .scale(scale: 1.1).combined(with: .opacity).animation(transitionAnimation),
                        removal: .scale(scale: 0.9).combined(with: .opacity).animation(transitionAnimation))
        )

        .background(createTapArea())
    }
}

private extension PopupCentreStackView {
    func a() -> some View {
        Group {
            ForEach(items, id: \.id, content: createPopup)
        }
    }


    func createPopup(_ item: AnyPopup<CentrePopupConfig>) -> some View {
        item.body
            .readHeight { saveHeight($0, for: items.last!) }
            .frame(width: width, height: height)
            .background(backgroundColour)
            .cornerRadius(cornerRadius)
    }
    func createTapArea() -> some View {
        Color.black.opacity(0.00000000001)
            .ignoresSafeArea()
            .frame(width: UIScreen.width, height: UIScreen.height)
            .onTapGesture(perform: items.last?.dismiss ?? {})
            .active(if: config.tapOutsideClosesView)
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
    var backgroundColour: Color { config.backgroundColour }
    var transitionAnimation: Animation { config.transitionAnimation }
    var config: CentrePopupConfig { items.last?.configurePopup(popup: .init()) ?? .init() }
}
