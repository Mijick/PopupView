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
import Combine
@testable import MijickPopups

final class PopupBottomStackViewModelTests: XCTestCase {
    @ObservedObject private var viewModel: PopupStackView.ViewModel = .init(alignment: .bottom)
    private var cancellables = Set<AnyCancellable>()


    override func setUpWithError() throws {
        viewModel.screen = screen
    }
}

// MARK: - Test Cases



// MARK: Calculating Popup Height
extension PopupBottomStackViewModelTests {
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
            largeScreenHeight
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
            largeScreenHeight - testHook.stackOffset * 4
        )
    }
    func test_calculatePopupHeight_withLargeHeightMode_whenOnePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 100)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            largeScreenHeight
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
            largeScreenHeight - testHook.stackOffset * 2
        )
    }
    func test_calculatePopupHeight_withFullscreenHeightMode_whenOnePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 100)
        ]

        XCTAssertEqual(
            calculateLastPopupHeight(),
            fullscreenHeight
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
            fullscreenHeight
        )
    }
}

// MARK: Calculating Active Popup Height
extension PopupBottomStackViewModelTests {
    func test_calculateActivePopupHeight_withAutoHeightMode_whenLessThanScreen_onePopupStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 100)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: 100
        )
    }
    func test_calculateActivePopupHeight_withAutoHeightMode_whenBiggerThanScreen_threePopupsStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 3000),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 1000),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 2000)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: largeScreenHeight - 2 * testHook.stackOffset
        )
    }
    func test_calculateActivePopupHeight_withLargeHeightMode_whenThreePopupsStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 350),
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 1000),
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 2000)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: largeScreenHeight - 2 * testHook.stackOffset
        )
    }
    func test_calculateActivePopupHeight_withAutoHeightMode_whenGestureIsNegative_twoPopupsStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 350),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 2000)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: -51,
            expectedValue: largeScreenHeight - testHook.stackOffset * 1 + 51
        )
    }
    func test_calculateActivePopupHeight_withLargeHeightMode_whenGestureIsNegative_onePopupStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 350)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: -99,
            expectedValue: largeScreenHeight + 99
        )
    }
    func test_calculateActivePopupHeight_withFullscreenHeightMode_whenGestureIsNegative_twoPopupsStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 100),
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 250)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: -21,
            expectedValue: fullscreenHeight
        )
    }
    func test_calculateActivePopupHeight_withAutoHeightMode_whenGestureIsPositive_threePopupsStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: 350),
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 1000),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 850)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: 100,
            expectedValue: 850
        )
    }
    func test_calculateActivePopupHeight_withFullscreenHeightMode_whenGestureIsPositive_onePopupStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 350)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: 31,
            expectedValue: fullscreenHeight
        )
    }
    func test_calculateActivePopupHeight_withAutoHeightMode_whenGestureIsNegative_hasDragHeightStored_twoPopupsStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 350),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 500, popupDragHeight: 100)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: -93,
            expectedValue: 500 + 100 + 93
        )
    }
    func test_calculateActivePopupHeight_withAutoHeightMode_whenGestureIsPositive_hasDragHeightStored_onePopupStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 1300, popupDragHeight: 100)
        ]

        appendPopupsAndCheckActivePopupHeight(
            popups: popups,
            gestureTranslation: 350,
            expectedValue: largeScreenHeight
        )
    }
}

// MARK: Calculating Offset
extension PopupBottomStackViewModelTests {
    func test_calculateOffsetY_withZeroGestureTranslation_fivePopupsStacked_thirdElement() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 350),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 120),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 240),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 670),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 310)
        ]

        XCTAssertEqual(
            testHook.calculatePopupOffsetY(for: viewModel.popups[2]),
            -testHook.stackOffset * 2
        )
    }
    func test_calculateOffsetY_withZeroGestureTranslation_fivePopupsStacked_lastElement() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 350),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 120),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 240),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 670),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 310)
        ]

        XCTAssertEqual(
            testHook.calculatePopupOffsetY(for: viewModel.popups[4]),
            0
        )
    }
    func test_calculateOffsetY_withNegativeGestureTranslation_dragHeight_onePopupStacked() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 350, popupDragHeight: 100)
        ]
        viewModel.gestureTranslation = -100

        XCTAssertEqual(
            testHook.calculatePopupOffsetY(for: viewModel.popups[0]),
            0
        )
    }
    func test_calculateOffsetY_withPositiveGestureTranslation_dragHeight_twoPopupsStacked_firstElement() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 350, popupDragHeight: 249),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 133, popupDragHeight: 21)
        ]
        viewModel.gestureTranslation = 100

        XCTAssertEqual(
            testHook.calculatePopupOffsetY(for: viewModel.popups[0]),
            -testHook.stackOffset
        )
    }
    func test_calculateOffsetY_withPositiveGestureTranslation_dragHeight_twoPopupsStacked_lastElement() {
        viewModel.popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 350, popupDragHeight: 249),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 133, popupDragHeight: 21)
        ]
        viewModel.gestureTranslation = 100

        XCTAssertEqual(
            testHook.calculatePopupOffsetY(for: viewModel.popups[1]),
            100 - 21
        )
    }
}


private extension PopupBottomStackViewModelTests {
    func appendPopupsAndCheckActivePopupHeight(popups: [AnyPopup], gestureTranslation: CGFloat, expectedValue: CGFloat) {
        viewModel.popups = popups
        viewModel.popups = recalculatePopupHeights()
        viewModel.gestureTranslation = gestureTranslation

        let expect = expectation(description: "results")
        viewModel.$activePopupHeight
            .dropFirst(3)
            .sink {
                XCTAssertEqual($0, expectedValue)
                expect.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expect], timeout: 3)
    }
}
private extension PopupBottomStackViewModelTests {
    func recalculatePopupHeights() -> [AnyPopup] { viewModel.popups.map {
        var popup = $0
        popup.height = testHook.calculatePopupHeight(height: $0.height!, popupConfig: $0.config as! Config)
        return popup
    }}
}





// MARK: - Helpers
private extension PopupBottomStackViewModelTests {
    func createPopupInstanceForPopupHeightTests(heightMode: HeightMode, popupHeight: CGFloat, popupDragHeight: CGFloat? = nil) -> AnyPopup {
        let config = getConfigForPopupHeightTests(heightMode: heightMode)

        var popup = AnyPopup(config: config)
        popup.height = popupHeight
        popup.dragHeight = popupDragHeight
        return popup
    }
    func calculateLastPopupHeight() -> CGFloat {
        testHook.calculatePopupHeight(height: viewModel.popups.last!.height!, popupConfig: viewModel.popups.last!.config as! Config)
    }
}
private extension PopupBottomStackViewModelTests {
    func getConfigForPopupHeightTests(heightMode: HeightMode) -> Config { .init(
        ignoredSafeAreaEdges: [],
        heightMode: heightMode,
        popupPadding: (0, 0, 0),
        dragGestureEnabled: true,
        dragDetents: []
    )}
}





private extension PopupBottomStackViewModelTests {
    typealias Config = LocalConfig.Vertical

    var testHook: PopupStackView<Config>.ViewModel.TestHook { viewModel.testHook }



    var fullscreenHeight: CGFloat { screen.height }
    var largeScreenHeight: CGFloat { fullscreenHeight - screen.safeArea.top }
}




// MARK: Helpers
private extension PopupBottomStackViewModelTests {
    var screen: ScreenProperties { .init(
        height: 1000,
        safeArea: .init(top: 100, leading: 0, bottom: 50, trailing: 0)
    )}
}
