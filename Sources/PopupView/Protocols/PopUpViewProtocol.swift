//
//  PopUpViewProtocol.swift of 
//
//  Created by Alina Petrovskaya
//    - Linkedin: https://www.linkedin.com/in/alina-petrovkaya-69617a10b
//    - Mail: alina.petrovskaya.12@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

protocol PopUpViewProtocol: View {
    associatedtype Config
    
    var items: [AnyPopup] { get }
    var closingAction: () -> () { get }
    var config: Config { get set }
    
    init(items: [AnyPopup], closingAction: @escaping () -> (), configBuilder: (inout Config) -> ())
}

extension PopUpViewProtocol {
    func close() -> Self {
        var items = items
        items.removeLast()
        var newView = Self.init(items: items, closingAction: closingAction, configBuilder: { _ in })
        newView.config = config
        return newView
    }
    func content() -> AnyView { AnyView(self) }
}
