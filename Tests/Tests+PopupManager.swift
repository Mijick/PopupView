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
    func test_getInstance_withNoActiveInstances() {
        let managerInstance = PopupManager.t_getInstance(id: .bronowice)
        XCTAssertNil(managerInstance)
    }
    func test_getInstance_withRegisteredOtherInstances() {
        registerNewInstances(popupManagerIds: [
            .krowodrza,
            .staremiasto,
            .pradnikczerwony,
            .pradnikbialy,
            .grzegorzki
        ])

        let managerInstance = PopupManager.t_getInstance(id: .bronowice)
        XCTAssertNil(managerInstance)
    }
    func test_getInstance_withRegisteredDemandedInstance() {
        registerNewInstances(popupManagerIds: [
            .krowodrza,
            .staremiasto,
            .grzegorzki
        ])

        let managerInstance = PopupManager.t_getInstance(id: .grzegorzki)
        XCTAssertNotNil(managerInstance)
    }
}

// MARK: Present Popup
extension PopupManagerTests {
    func test_presentPopup() {
        let a = AnyPopup(config: .init())


    }
    func test_2() {

    }


    // ze odpowiednio rozpoznaje config
    // ze prezentuje to poprawnie
    // ze dziala stack i replace
    // ze sie odpowiednio zwieksza liczba popupow
    // ze sie nie da prezentowac z tym samym idem
    // ale ze sie da prezentowac z custom id
    // ze sie wylaczy po danym czasie
}

// MARK: Dismiss Popup
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
