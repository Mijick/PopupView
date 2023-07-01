//
//  GlobalConfig.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


public extension GlobalConfig {
    func main(_ configure: (Common) -> Common) -> GlobalConfig { changing(path: \.common, to: configure(.init())) }
    func top(_ configure: (Top) -> Top) -> GlobalConfig { changing(path: \.top, to: configure(.init())) }
    func centre(_ configure: (Centre) -> Centre) -> GlobalConfig { changing(path: \.centre, to: configure(.init())) }
    func bottom(_ configure: (Bottom) -> Bottom) -> GlobalConfig { changing(path: \.bottom, to: configure(.init())) }
}


// MARK: - Internal
public struct GlobalConfig: Configurable { public init() {}
    var common: Common = .init()
    var top: Top = .init()
    var centre: Centre = .init()
    var bottom: Bottom = .init()
}
