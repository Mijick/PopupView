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

// MARK: Equality
extension PopupIDTests {
    func test_popupIdsEqual_1() {




    }
    func test_popupIdsEqual_2() {

    }
}

// MARK: Ze takie cos ~=
extension PopupIDTests {
    
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
