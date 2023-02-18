//
//  PopupManager.swift of PopupView
//
//  Created by Alina Petrovskaya
//    - Linkedin: https://www.linkedin.com/in/alina-petrovkaya-69617a10b
//    - Mail: alina.petrovskaya.12@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.

import SwiftUI

public class PopupManager: ObservableObject {
    private let viewsManager = ViewsManager()
    //internal var activeView: CustomPopupView? { viewsManager.activeView }
    public static let shared = PopupManager()
    
    
    private init() { }
}

public extension PopupManager {
    //func close() { viewsManager.delete() }
    //func closeAll() { viewsManager.clear() }
}

extension PopupManager {
    //func open(_ view: AnyView, id: String, completion: Modification? = nil) { viewsManager.add(view, id: id, with: completion?(.init())) }
}
