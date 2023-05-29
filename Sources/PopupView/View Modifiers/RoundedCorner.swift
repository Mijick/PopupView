//
//  RoundedCorner.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension View {
    func background(_ colour: Color, radius: CGFloat, corners: UIRectCorner) -> some View { background(RoundedCorner(radius: radius, corners: corners).fill(colour)) }
}

// MARK: - Implementation
fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    
    var animatableData: CGFloat {
        get { radius }
        set { radius = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
