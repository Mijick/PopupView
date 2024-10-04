//
//  Tests+PopupManager.swift of MijickPopups
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import XCTest
import SwiftUI
import Combine
@testable import MijickPopups

final class PopupManagerTests: XCTestCase {




    // co testować:
    // 1. Tworzenie instancji
    // 2. Pobieranie instancji o danym id
    // 3. Operacje na views
    
}



// MARK: - TEST CASES



// MARK: Register New Instance
extension PopupManagerTests {
    func test_registerNewInstance_1() {
        PopupManager.registerNewInstance(id: .shared)

        PopupManagerRegistry.instances.count
    }
    func test_registerNewInstance_2() {
        PopupManager.registerNewInstance(id: .shared)

        PopupManagerRegistry.instances.count
    }
    func test_registerNewInstance_3() {
        PopupManager.registerNewInstance(id: .shared)

        PopupManagerRegistry.instances.count
    }
}

// MARK: Get Instance
extension PopupManagerTests {

}

// MARK: Insert Operations
extension PopupManagerTests {
    
}

// MARK: Remove Operations
extension PopupManagerTests {

}


// MARK: - HELPERS



// MARK: Methods
private extension PopupManagerTests {

}
private extension PopupManagerTests {

}

// MARK: Popup Manager Identifiers
private extension PopupManagerID {
    static let staremiasto: Self = .init(rawValue: "staremiasto")
    static let grzegorzki: Self = .init(rawValue: "grzegorzki")
    static let pradnikczerwony: Self = .init(rawValue: "pradnikczerwony")
    static let pradnikbialy: Self = .init(rawValue: "pradnikbialy")
    static let krowodrza: Self = .init(rawValue: "krowodrza")
    static let bronowice: Self = .init(rawValue: "bronowice")
}
