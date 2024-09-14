//
//  ConfigContainer.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


public extension ConfigContainer {
    func vertical(_ configure: (GlobalConfig.Vertical) -> GlobalConfig.Vertical) -> ConfigContainer { Self.vertical = configure(.init()); return self }
    func centre(_ configure: (GlobalConfig.Centre) -> GlobalConfig.Centre) -> ConfigContainer { Self.centre = configure(.init()); return self }
}


// MARK: - Internal
public class ConfigContainer {
    static var vertical: GlobalConfig.Vertical = .init()
    static var centre: GlobalConfig.Centre = .init()
}
