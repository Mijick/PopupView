//
//  Tests+ViewModel+PopupCentreStack.swift of MijickPopups
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

final class PopupCentreStackViewModelTests: XCTestCase {
    @ObservedObject private var viewModel: ViewModel = .init()
    private var cancellables: Set<AnyCancellable> = .init()

    override func setUpWithError() throws {
        viewModel.t_updateScreenValue(screen)
        viewModel.t_setup(updatePopupAction: { [self] in updatePopupAction(viewModel, $0) }, closePopupAction: { [self] in closePopupAction(viewModel, $0) })
    }
}
private extension PopupCentreStackViewModelTests {
    func updatePopupAction(_ viewModel: ViewModel, _ popup: AnyPopup) { if let index = viewModel.popups.firstIndex(of: popup) {
        var popups = viewModel.popups
        popups[index] = popup

        viewModel.t_updatePopupsValue(popups)
        viewModel.t_calculateAndUpdateActivePopupHeight()
    }}
    func closePopupAction(_ viewModel: ViewModel, _ popup: AnyPopup) { if let index = viewModel.popups.firstIndex(of: popup) {
        var popups = viewModel.popups
        popups.remove(at: index)

        viewModel.t_updatePopupsValue(popups)
    }}
}



// MARK: - TEST CASES



// MARK: Popup Padding
extension PopupCentreStackViewModelTests {
    func test_calculatePopupPadding_withKeyboardHidden_whenCustomPaddingNotSet() {
        let popups = [
            createPopupInstanceForPopupHeightTests(popupHeight: 350),
            createPopupInstanceForPopupHeightTests(popupHeight: 72),
            createPopupInstanceForPopupHeightTests(popupHeight: 400)
        ]

        appendPopupsAndCheckPopupPadding(
            popups: popups,
            expectedValue: .init()
        )
    }
    func test_calculatePopupPadding_withKeyboardHidden_whenCustomPaddingSet() {
        let popups = [
            createPopupInstanceForPopupHeightTests(popupHeight: 350),
            createPopupInstanceForPopupHeightTests(popupHeight: 72, popupPadding: .init(top: 0, leading: 11, bottom: 0, trailing: 11)),
            createPopupInstanceForPopupHeightTests(popupHeight: 400, popupPadding: .init(top: 0, leading: 16, bottom: 0, trailing: 16))
        ]

        appendPopupsAndCheckPopupPadding(
            popups: popups,
            expectedValue: .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        )
    }
    func test_calculatePopupPadding_withKeyboardShown_whenKeyboardWontOverlapPopup() {

    }
    func test_calculatePopupPadding_withKeyboardShown_whenKeyboardWillOverlapPopup() {

    }
}
private extension PopupCentreStackViewModelTests {
    func appendPopupsAndCheckPopupPadding(popups: [AnyPopup], expectedValue: EdgeInsets) {
        appendPopupsAndPerformChecks(
            popups: popups,
            calculatedValue: { $0.t_calculatePopupPadding() },
            expectedValueBuilder: { _ in expectedValue }
        )
    }
}

// MARK: Corner Radius
extension PopupCentreStackViewModelTests {
    func test_calculateCornerRadius_withCornerRadiusZero() {

    }
    func test_calculateCornerRadius_withCornerRadiusNonZero() {

    }
}

// MARK: Opacity
extension PopupCentreStackViewModelTests {
    func test_calculatePopupOpacity_1() {

    }
    func test_calculatePopupOpacity_2() {

    }
}

// MARK: Vertical Fixed Size
extension PopupCentreStackViewModelTests {
    func test_verticalFixedSize_withHeightSmallerThanScreen() {

    }
    func test_verticalFixedSize_withHeightLargerThanScreen() {

    }
}



// MARK: - HELPERS



// MARK: Methods
private extension PopupCentreStackViewModelTests {
    func createPopupInstanceForPopupHeightTests(popupHeight: CGFloat, popupPadding: EdgeInsets = .init(), cornerRadius: CGFloat = 0) -> AnyPopup {
        let config = getConfigForPopupHeightTests(cornerRadius: cornerRadius, popupPadding: popupPadding)

        var popup = AnyPopup(config: config)
        popup.height = popupHeight
        return popup
    }
    func appendPopupsAndPerformChecks<Value: Equatable>(popups: [AnyPopup], calculatedValue: @escaping (ViewModel) -> (Value), expectedValueBuilder: @escaping (ViewModel) -> Value) {
        viewModel.t_updatePopupsValue(popups)
        viewModel.t_updatePopupsValue(recalculatePopupHeights(viewModel))

        let expect = expectation(description: "results")
        viewModel.objectWillChange
            .receive(on: RunLoop.main)
            .dropFirst(2)
            .sink { [self] in
                XCTAssertEqual(calculatedValue(viewModel), expectedValueBuilder(viewModel))
                expect.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expect], timeout: 3)
    }
}
private extension PopupCentreStackViewModelTests {
    func getConfigForPopupHeightTests(cornerRadius: CGFloat, popupPadding: EdgeInsets) -> Config { .init(
        cornerRadius: cornerRadius,
        popupPadding: popupPadding
    )}
    func recalculatePopupHeights(_ viewModel: ViewModel) -> [AnyPopup] { viewModel.popups.map {
        var popup = $0
        popup.height = viewModel.t_calculateHeight(heightCandidate: $0.height!)
        return popup
    }}
}

// MARK: Screen
private extension PopupCentreStackViewModelTests {
    var screen: ScreenProperties { .init(
        height: 1000,
        safeArea: .init(top: 100, leading: 20, bottom: viewModel.isKeyboardActive ? 200 : 50, trailing: 30)
    )}
}

// MARK: Typealiases
private extension PopupCentreStackViewModelTests {
    typealias Config = LocalConfig.Centre
    typealias ViewModel = PopupCentreStackView.ViewModel
}
