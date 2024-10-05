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
    
}

// MARK: Equality
extension PopupIDTests {

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
