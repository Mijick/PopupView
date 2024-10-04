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
    // 2. Pobieranie instancji o danym id
    // 3. Operacje na views

    override func setUpWithError() throws {
        PopupManagerRegistry.t_clean()
    }
}



// MARK: - TEST CASES



// MARK: Register New Instance
extension PopupManagerTests {
    func test_registerNewInstance_withNoInstancesToRegister() {
        let popupManagerIds: [PopupManagerID] = []

        registerNewInstances(popupManagerIds: popupManagerIds)
        XCTAssertEqual(popupManagerIds, getRegisteredInstances())
    }
    func test_registerNewInstance_withUniqueInstancesToRegister() {
        let popupManagerIds: [PopupManagerID] = [
            .staremiasto,
            .grzegorzki,
            .krowodrza,
            .bronowice
        ]

        registerNewInstances(popupManagerIds: popupManagerIds)
        XCTAssertEqual(popupManagerIds, getRegisteredInstances())
    }
    func test_registerNewInstance_withRepeatingInstancesToRegister() {
        let popupManagerIds: [PopupManagerID] = [
            .staremiasto,
            .grzegorzki,
            .krowodrza,
            .bronowice,
            .bronowice,
            .pradnikbialy,
            .pradnikczerwony,
            .krowodrza
        ]

        registerNewInstances(popupManagerIds: popupManagerIds)
        XCTAssertNotEqual(popupManagerIds, getRegisteredInstances())
    }
}
private extension PopupManagerTests {
    func registerNewInstances(popupManagerIds: [PopupManagerID]) {
        popupManagerIds.forEach { _ = PopupManager.t_registerNewInstance(id: $0) }
    }
    func getRegisteredInstances() -> [PopupManagerID] {
        PopupManagerRegistry.t_instances.map(\.id)
    }
}

// MARK: Get Instance
extension PopupManagerTests {
    func test_getInstance_1() {
        //PopupManager.getInstance(<#T##id: PopupManagerID##PopupManagerID#>)
    }
    func test_getInstance_2() {

    }
    func test_getInstance_3() {

    }
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
