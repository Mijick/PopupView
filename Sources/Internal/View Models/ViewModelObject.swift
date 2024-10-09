//
//  ViewModelObject.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

@MainActor protocol ViewModelObject: ObservableObject {
    associatedtype Config = LocalConfig

    func setup(updatePopupAction: @escaping (AnyPopup) -> (), closePopupAction: @escaping (AnyPopup) -> ())
    func updatePopupsValue(_ newPopups: [AnyPopup])
    func updateScreenValue(_ newScreen: Screen)
    func updateKeyboardValue(_ isActive: Bool)
    func getConfig(_ item: AnyPopup?) -> Config
    func getActivePopupConfig() -> Config
}
