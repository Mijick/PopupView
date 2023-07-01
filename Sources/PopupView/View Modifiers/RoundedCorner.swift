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
    func background(_ backgroundColour: Color, overlayColour: Color, radius: CGFloat, corners: RectCorner) -> some View {
        overlay(RoundedCorner(radius: radius, corners: corners).fill(overlayColour))
            .background(RoundedCorner(radius: radius, corners: corners).fill(backgroundColour))
    }
}

// MARK: - Implementation
fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: RectCorner

    
    var animatableData: CGFloat {
        get { radius }
        set { radius = newValue }
    }
    func path(in rect: CGRect) -> Path {
        let points = createPoints(rect)
        let path = createPath(rect, points)
        return path
    }
}
private extension RoundedCorner {
    func createPoints(_ rect: CGRect) -> [CGPoint] {[
        .init(x: rect.minX, y: corners.contains(.topLeft) ? rect.minY + radius  : rect.minY),
        .init(x: corners.contains(.topLeft) ? rect.minX + radius : rect.minX, y: rect.minY ),
        .init(x: corners.contains(.topRight) ? rect.maxX - radius : rect.maxX, y: rect.minY ),
        .init(x: rect.maxX, y: corners.contains(.topRight) ? rect.minY + radius  : rect.minY ),
        .init(x: rect.maxX, y: corners.contains(.bottomRight) ? rect.maxY - radius : rect.maxY ),
        .init(x: corners.contains(.bottomRight) ? rect.maxX - radius : rect.maxX, y: rect.maxY ),
        .init(x: corners.contains(.bottomLeft) ? rect.minX + radius : rect.minX, y: rect.maxY ),
        .init(x: rect.minX, y: corners.contains(.bottomLeft) ? rect.maxY - radius : rect.maxY )
    ]}
    func createPath(_ rect: CGRect, _ points: [CGPoint]) -> Path {
        var path = Path()

        path.move(to: points[0])
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY), tangent2End: points[1], radius: radius)
        path.addLine(to: points[2])
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY), tangent2End: points[3], radius: radius)
        path.addLine(to: points[4])
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End: points[5], radius: radius)
        path.addLine(to: points[6])
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End: points[7], radius: radius)
        path.closeSubpath()

        return path
    }
}


struct RectCorner: OptionSet {
    let rawValue: Int
}
extension RectCorner {
    static let topLeft = RectCorner(rawValue: 1 << 0)
    static let topRight = RectCorner(rawValue: 1 << 1)
    static let bottomRight = RectCorner(rawValue: 1 << 2)
    static let bottomLeft = RectCorner(rawValue: 1 << 3)
    static let allCorners: RectCorner = [.topLeft, topRight, .bottomLeft, .bottomRight]
}
