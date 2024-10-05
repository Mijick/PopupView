//
//  Tests+PopupID.swift of MijickPopups
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

final class PopupIDTests: XCTestCase {}



// MARK: - TEST CASES



// MARK: Create ID
extension PopupIDTests {
    func test_createPopupID_1() {
        let dateString = String(describing: Date())

        let popupID = PopupID.create(from: TestTopPopup.self)
        let idComponents = popupID.rawValue.components(separatedBy: "/{}/")

        XCTAssertEqual(idComponents.count, 2)
        XCTAssertEqual(idComponents[0], "TestTopPopup")
        XCTAssertEqual(idComponents[1], dateString)
    }
    func test_createPopupID_2() {
        let dateString = String(describing: Date())

        let popupID = PopupID.create(from: TestCentrePopup.self)
        let idComponents = popupID.rawValue.components(separatedBy: "/{}/")

        XCTAssertEqual(idComponents.count, 2)
        XCTAssertEqual(idComponents[0], "TestCentrePopup")
        XCTAssertEqual(idComponents[1], dateString)
    }
}

// MARK: Is Same Type
extension PopupIDTests {
    func test_isSameType_1() {
        let popupID1 = PopupID.create(from: TestTopPopup.self),
            popupID2 = PopupID.create(from: TestBottomPopup.self)

        let result = popupID1.isSameType(as: popupID2)
        XCTAssertEqual(result, false)
    }
    func test_isSameType_2() {

    }
    func test_isSameType_3() {

    }
}

// MARK: Is Same Instance
extension PopupIDTests {
    func test_isSameInstance_1() {

    }
    func test_isSameInstance_2() {

    }
    func test_isSameInstance_3() {

    }
}



// MARK: - HELPERS



// MARK: Test Popups
private struct TestTopPopup: TopPopup {
    func createContent() -> some View { EmptyView() }
}
private struct TestCentrePopup: CentrePopup {
    func createContent() -> some View { EmptyView() }
}
private struct TestBottomPopup: BottomPopup {
    func createContent() -> some View { EmptyView() }
}
