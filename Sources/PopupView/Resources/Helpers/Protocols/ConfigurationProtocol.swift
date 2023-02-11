//
//  ConfigurationProtocol.swift of
//
//  Created by Alina Petrovskaya
//    - Linkedin: https://www.linkedin.com/in/alina-petrovkaya-69617a10b
//    - Mail: alina.petrovskaya.12@icloud.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import Foundation

protocol ConfigurationProtocol { }

extension ConfigurationProtocol {
    func update(modify: (inout Self) -> ()) -> Self {
        var item = self
        modify(&item)
        return item
    }
}
