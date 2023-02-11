//
//  +View.swift
//  
//
//  Created by Alina Petrovskaya on 11.02.2023.
//

import SwiftUI

public extension View {
    func open(with modification: Modification? = nil) {
        let id = String(describing: self)
        PopupManager.shared.open(self.toAnyView, id: id, completion: modification)
    }
}

extension View {
    var toAnyView: AnyView { AnyView(self) }
}

