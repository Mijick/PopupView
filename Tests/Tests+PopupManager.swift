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
@testable import MijickPopups

@MainActor final class PopupManagerTests: XCTestCase {
    override func setUp() async throws {
        PopupManagerRegistry.clean()
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
        XCTAssertEqual(getRegisteredInstances().count, 6)
    }
}
private extension PopupManagerTests {
    func registerNewInstances(popupManagerIds: [PopupManagerID]) {
        popupManagerIds.forEach { _ = PopupManager.registerInstance(id: $0) }
    }
    func getRegisteredInstances() -> [PopupManagerID] {
        PopupManagerRegistry.instances.map(\.id)
    }
}

// MARK: Get Instance
extension PopupManagerTests {
    func test_getInstance_whenNoInstancesAreRegistered() {
        let managerInstance = PopupManager.getInstance(.bronowice)
        XCTAssertNil(managerInstance)
    }
    func test_getInstance_whenInstanceIsNotRegistered() {
        registerNewInstances(popupManagerIds: [
            .krowodrza,
            .staremiasto,
            .pradnikczerwony,
            .pradnikbialy,
            .grzegorzki
        ])

        let managerInstance = PopupManager.getInstance(.bronowice)
        XCTAssertNil(managerInstance)
    }
    func test_getInstance_whenInstanceIsRegistered() {
        registerNewInstances(popupManagerIds: [
            .krowodrza,
            .staremiasto,
            .grzegorzki
        ])

        let managerInstance = PopupManager.getInstance(.grzegorzki)
        XCTAssertNotNil(managerInstance)
    }
}

// MARK: Present Popup
extension PopupManagerTests {
    func test_presentPopup_withThreePopupsToBePresented() {
        registerNewInstanceAndPresentPopups(popups: [
            AnyPopup(config: .init()),
            AnyPopup(config: .init()),
            AnyPopup(config: .init())
        ])

        let popupsOnStack = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack.count, 3)
    }
    func test_presentPopup_withPopupsWithSameID() {
        registerNewInstanceAndPresentPopups(popups: [
            AnyPopup(id: "2137", config: .init()),
            AnyPopup(id: "2137", config: .init()),
            AnyPopup(id: "2331", config: .init())
        ])

        let popupsOnStack = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack.count, 2)
    }
    func test_presentPopup_withCustomID() {
        registerNewInstanceAndPresentPopups(popups: [
            AnyPopup(id: "2137", config: .init()).setCustomID("1"),
            AnyPopup(id: "2137", config: .init()),
            AnyPopup(id: "2137", config: .init()).setCustomID("3")
        ])

        let popupsOnStack = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack.count, 3)
    }
    func test_presentPopup_withDismissAfter() async {
        registerNewInstanceAndPresentPopups(popups: [
            AnyPopup(config: .init()).dismissAfter(0.7),
            AnyPopup(config: .init()),
            AnyPopup(config: .init()).dismissAfter(1.5)
        ])

        let popupsOnStack1 = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack1.count, 3)

        await Task.sleep(seconds: 1)

        let popupsOnStack2 = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack2.count, 2)

        await Task.sleep(seconds: 1)

        let popupsOnStack3 = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack3.count, 1)
    }
}

// MARK: Dismiss Popup
extension PopupManagerTests {
    func test_dismissLastPopup_withNoPopupsOnStack() {
        registerNewInstanceAndPresentPopups(popups: [])
        PopupManager.dismiss(manID: defaultPopupManagerID)

        let popupsOnStack = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack.count, 0)
    }
    func test_dismissLastPopup_withThreePopupsOnStack() {
        registerNewInstanceAndPresentPopups(popups: [
            AnyPopup(config: .init()),
            AnyPopup(config: .init()),
            AnyPopup(config: .init())
        ])
        PopupManager.dismiss(manID: defaultPopupManagerID)

        let popupsOnStack = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack.count, 2)
    }
    func test_dismissPopupWithType_whenPopupOnStack() {
        let popups: [AnyPopup] = [
            .init(TestTopPopup(), id: nil),
            .init(TestCentrePopup(), id: nil),
            .init(TestBottomPopup(), id: nil)
        ]
        registerNewInstanceAndPresentPopups(popups: popups)

        let popupsOnStackBefore = getPopupsForActiveInstance()
        XCTAssertEqual(popups, popupsOnStackBefore)

        PopupManager.dismissPopup(TestBottomPopup.self, manID: defaultPopupManagerID)

        let popupsOnStackAfter = getPopupsForActiveInstance()
        XCTAssertEqual([popups[0], popups[1]], popupsOnStackAfter)
    }
    func test_dismissPopupWithType_whenPopupNotOnStack() {
        let popups: [AnyPopup] = [
            .init(TestTopPopup(), id: nil),
            .init(TestBottomPopup(), id: nil)
        ]
        registerNewInstanceAndPresentPopups(popups: popups)

        let popupsOnStackBefore = getPopupsForActiveInstance()
        XCTAssertEqual(popups, popupsOnStackBefore)

        PopupManager.dismissPopup(TestCentrePopup.self, manID: defaultPopupManagerID)

        let popupsOnStackAfter = getPopupsForActiveInstance()
        XCTAssertEqual(popups, popupsOnStackAfter)
    }
    func test_dismissPopupWithType_whenPopupHasCustomID() {
        let popups: [AnyPopup] = [
            .init(TestTopPopup().setCustomID("2137"), id: nil),
            .init(TestBottomPopup(), id: nil)
        ]
        registerNewInstanceAndPresentPopups(popups: popups)

        let popupsOnStackBefore = getPopupsForActiveInstance()
        XCTAssertEqual(popups, popupsOnStackBefore)

        PopupManager.dismissPopup(TestTopPopup.self, manID: defaultPopupManagerID)

        let popupsOnStackAfter = getPopupsForActiveInstance()
        XCTAssertEqual(popups, popupsOnStackAfter)
    }
    func test_dismissPopupWithID_whenPopupHasCustomID() {
        let popups: [AnyPopup] = [
            .init(TestTopPopup().setCustomID("2137"), id: nil),
            .init(TestBottomPopup(), id: nil)
        ]
        registerNewInstanceAndPresentPopups(popups: popups)

        let popupsOnStackBefore = getPopupsForActiveInstance()
        XCTAssertEqual(popups, popupsOnStackBefore)

        PopupManager.dismissPopup(id: "2137", manID: defaultPopupManagerID)

        let popupsOnStackAfter = getPopupsForActiveInstance()
        XCTAssertEqual([popups[1]], popupsOnStackAfter)
    }
    func test_dismissAllPopups() {
        registerNewInstanceAndPresentPopups(popups: [
            AnyPopup(config: .init()),
            AnyPopup(config: .init()),
            AnyPopup(config: .init())
        ])
        PopupManager.dismissAll(manID: defaultPopupManagerID)

        let popupsOnStack = getPopupsForActiveInstance()
        XCTAssertEqual(popupsOnStack.count, 0)
    }
}



// MARK: - HELPERS



// MARK: Methods
private extension PopupManagerTests {
    func registerNewInstanceAndPresentPopups(popups: [any Popup]) {
        registerNewInstances(popupManagerIds: [defaultPopupManagerID])
        popups.forEach { $0.present(id: defaultPopupManagerID) }
    }
    func getPopupsForActiveInstance() -> [AnyPopup] {
        PopupManager
            .getInstance(defaultPopupManagerID)?
            .stack ?? []
    }
}

// MARK: Variables
private extension PopupManagerTests {
    var defaultPopupManagerID: PopupManagerID { .staremiasto }
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

// MARK: Test Popups
private struct TestTopPopup: TopPopup {
    var body: some View { EmptyView() }
}
private struct TestCentrePopup: CentrePopup {
    var body: some View { EmptyView() }
}
private struct TestBottomPopup: BottomPopup {
    var body: some View { EmptyView() }
}
