//
//  CustomPopupView.swift
//  
//  Created by Alina Petrovskaya
//    - Linkedin: https://www.linkedin.com/in/alina-petrovkaya-69617a10b
//    - Mail: alina.petrovskaya.12@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.

import SwiftUI

public struct CustomPopupView: Identifiable {
    private let view: AnyView
    internal var config: ConfigurableData
    public let id: String
    
    
    init(_ view: AnyView, _ id: String, _ config: ConfigurableData?) { self.view = view; self.id = id; self.config = config ?? .init() }
}

//MARK: -Configurable Data
public extension CustomPopupView {
    struct ConfigurableData: ConfigurationProtocol {
        var transition: AnyTransition = Config.Transition.transition
        var width: CGFloat = Config.Size.width
        var height: CGFloat? = nil
        var cornerRadius: CGFloat = Config.Size.corners
        var corners: UIRectCorner = Config.Corner.corners
    }
}

public extension CustomPopupView.ConfigurableData {
    func width(_ value: CGFloat) -> Self { update { $0.width = value }}
    func height(_ value: CGFloat) -> Self  { update { $0.height = value }}
    func transition(_ value: AnyTransition) -> Self  { update { $0.transition = value }}
    func cornerRadius(_ value: CGFloat) -> Self  { update { $0.cornerRadius = value }}
    func corners(_ value: UIRectCorner) -> Self  { update { $0.corners = value }}
}
