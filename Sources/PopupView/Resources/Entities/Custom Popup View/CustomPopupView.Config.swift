//
//  CustomPopupView.Config.swift of
//
//  Created by Alina Petrovskaya
//    - Linkedin: https://www.linkedin.com/in/alina-petrovkaya-69617a10b
//    - Mail: alina.petrovskaya.12@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

extension CustomPopupView {
    enum Config { }
}

extension CustomPopupView.Config {
    enum Size {
        static let corners: CGFloat = 24
        static let width: CGFloat = UIScreen.width
    }
    enum Corner {
        static let corners: UIRectCorner = [.topLeft, .topRight]
    }
    enum Transition {
        static let transition: AnyTransition = .slide
    }
}
