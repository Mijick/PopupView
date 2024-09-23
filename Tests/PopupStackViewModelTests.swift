//
//  PopupStackViewModelTests.swift of MijickPopups
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

final class PopupStackViewModelTests: XCTestCase {
    @ObservedObject private var viewModel: PopupStackView.ViewModel = .init(alignment: .bottom)


    override func setUpWithError() throws {
        viewModel.screen = screen
    }
}

// MARK: Calculating Popup Height
extension PopupStackViewModelTests {
    func test_calculatePopupHeight_withAutoHeightMode_whenLessThanScreen_onePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 150)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            150.0
        )
    }
    func test_calculatePopupHeight_withAutoHeightMode_whenLessThanScreen_fourPopupsStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 150),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 200),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 100)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            100.0
        )
    }
    func test_calculatePopupHeight_withAutoHeightMode_whenBiggerThanScreen_onePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 2000)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            screen.height - screen.safeArea.top
        )
    }
    func test_calculatePopupHeight_withAutoHeightMode_whenBiggerThanScreen_fivePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 150),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 200),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 100),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 2000)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            screen.height - screen.safeArea.top - testHook.stackOffset * 4
        )
    }
    func test_calculatePopupHeight_withLargeHeightMode_whenOnePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 100)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            screen.height - screen.safeArea.top
        )
    }
    func test_calculatePopupHeight_withLargeHeightMode_whenThreePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 100),
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 700),
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 1000)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            screen.height - screen.safeArea.top - testHook.stackOffset * 2
        )
    }
    func test_calculatePopupHeight_withFullscreenHeightMode_whenOnePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 100)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            screen.height
        )
    }
    func test_calculatePopupHeight_withFullscreenHeightMode_whenThreePopupsStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 100),
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 2000),
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 3000)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            screen.height
        )
    }
}
private extension PopupStackViewModelTests {
    func createPopupInstanceForPopupHeightTests(heightMode: HeightMode, popupHeight: CGFloat) -> AnyPopup {
        let config = getConfigForPopupHeightTests(heightMode: heightMode)

        var popup = AnyPopup(config: config)
        popup.height = popupHeight
        return popup
    }
    func calculateLastPopupHeight() -> CGFloat {
        testHook.calculatePopupHeight(height: viewModel.popups.last!.height!, popupConfig: viewModel.popups.last!.config as! Config)
    }
}
private extension PopupStackViewModelTests {
    func getConfigForPopupHeightTests(heightMode: HeightMode) -> Config { .init(
        ignoredSafeAreaEdges: [],
        heightMode: heightMode,
        popupPadding: (0, 0, 0),
        dragGestureEnabled: true,
        dragDetents: []
    )}
}



fileprivate typealias Config = LocalConfig.Vertical






private extension PopupStackViewModelTests {
    var testHook: PopupStackView<Config>.ViewModel.TestHook { viewModel.testHook }
}




// MARK: Helpers
private extension PopupStackViewModelTests {
    var screen: ScreenProperties { .init(
        height: 1000,
        safeArea: .init(top: 100, leading: 0, bottom: 50, trailing: 0)
    )}
}
