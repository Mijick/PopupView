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
    func background(_ backgroundColour: Color, overlayColour: Color, radius: CGFloat, corners: RectCorner, shadow: Shadow) -> some View {
        overlay(createRoundedCorner(overlayColour, radius, corners))
            .background(createRoundedCorner(backgroundColour, radius, corners).createShadow(shadow))
    }
}
private extension View {
    func createRoundedCorner(_ colour: Color, _ radius: CGFloat, _ corners: RectCorner) -> some View { createShape(radius, corners).fill(colour) }
    func createShadow(_ shadowAttributes: Shadow) -> some View { shadow(color: shadowAttributes.color, radius: shadowAttributes.radius, x: shadowAttributes.x, y: shadowAttributes.y) }
}
private extension View {
    func createShape(_ radius: CGFloat, _ corners: RectCorner) -> some Shape {
        if #available(iOS 16.0, macOS 13, tvOS 16, watchOS 9.0, *) {
            let values = getValues(corners, radius)
            return UnevenRoundedRectangle(topLeadingRadius: values.topLeft, bottomLeadingRadius: values.bottomLeft, bottomTrailingRadius: values.bottomRight, topTrailingRadius: values.topRight, style: .continuous)
        }
        return RoundedCorner(radius: radius, corners: corners)
    }
}
private extension View {
    func getValues(_ corners: RectCorner, _ radius: CGFloat) -> (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) { (
        topLeft: corners.contains(.topLeft) ? radius : 0,
        topRight: corners.contains(.topRight) ? radius : 0,
        bottomLeft: corners.contains(.bottomLeft) ? radius : 0,
        bottomRight: corners.contains(.bottomRight) ? radius : 0
    )}
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
    func createPath(_ rect: CGRect, _ points: [CGPoint]) -> Path { let radius = corners.values.max() ?? 0
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
