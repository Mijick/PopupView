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

// MARK: Calculating Body Padding
extension PopupBottomStackViewModelTests {
    func test_calculateBodyPadding_withDefaultSettings() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 350)
        ]

        appendPopupsAndCheckBodyPadding(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: .init(top: screen.safeArea.top, leading: screen.safeArea.leading, bottom: screen.safeArea.bottom, trailing: screen.safeArea.trailing)
        )
    }
    func test_calculateBodyPadding_withIgnoringSafeArea_bottom() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 200, ignoredSafeAreaEdges: .bottom)
        ]

        appendPopupsAndCheckBodyPadding(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: .init(top: 0, leading: screen.safeArea.leading, bottom: 0, trailing: screen.safeArea.trailing)
        )
    }
    func test_calculateBodyPadding_withIgnoringSafeArea_all() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 1200, ignoredSafeAreaEdges: .all)
        ]

        appendPopupsAndCheckBodyPadding(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
    }
    func test_calculateBodyPadding_withPopupPadding() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 1200, popupPadding: (top: 21, bottom: 37, horizontal: 12))
        ]

        appendPopupsAndCheckBodyPadding(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: .init(top: 0, leading: screen.safeArea.leading, bottom: screen.safeArea.bottom - 37, trailing: screen.safeArea.trailing)
        )
    }
    func test_calculateBodyPadding_withFullscreenHeightMode_ignoringSafeArea_top() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 100, ignoredSafeAreaEdges: .top)
        ]

        appendPopupsAndCheckBodyPadding(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: .init(top: 0, leading: screen.safeArea.leading, bottom: screen.safeArea.bottom, trailing: screen.safeArea.trailing)
        )
    }
    func test_calculateBodyPadding_withGestureTranslation() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 800)
        ]

        appendPopupsAndCheckBodyPadding(
            popups: popups,
            gestureTranslation: -300,
            expectedValue: .init(top: screen.safeArea.top, leading: screen.safeArea.leading, bottom: screen.safeArea.bottom, trailing: screen.safeArea.trailing)
        )
    }
    func test_calculateBodyPadding_withGestureTranslation_dragHeight() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, popupDragHeight: 700)
        ]

        appendPopupsAndCheckBodyPadding(
            popups: popups,
            gestureTranslation: 21,
            expectedValue: .init(top: screen.safeArea.top - 21, leading: screen.safeArea.leading, bottom: screen.safeArea.bottom, trailing: screen.safeArea.trailing)
        )
    }
}

// MARK: Calculating Translation Progress
extension PopupBottomStackViewModelTests {
    func test_calculateTranslationProgress_withNoGestureTranslation() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300)
        ]

        appendPopupsAndCheckTranslationProgress(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: 0
        )
    }
    func test_calculateTranslationProgress_withPositiveGestureTranslation() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300)
        ]

        appendPopupsAndCheckTranslationProgress(
            popups: popups,
            gestureTranslation: 250,
            expectedValue: 250 / 300
        )
    }
    func test_calculateTranslationProgress_withPositiveGestureTranslation_dragHeight() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, popupDragHeight: 120)
        ]

        appendPopupsAndCheckTranslationProgress(
            popups: popups,
            gestureTranslation: 250,
            expectedValue: (250 - 120) / 300
        )
    }
    func test_calculateTranslationProgress_withNegativeGestureTranslation() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300)
        ]

        appendPopupsAndCheckTranslationProgress(
            popups: popups,
            gestureTranslation: -175,
            expectedValue: 0
        )
    }
}

// MARK: Calculating Corner Radius
extension PopupBottomStackViewModelTests {
    func test_calculateCornerRadius_withTwoPopupsStacked() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, cornerRadius: 1),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, cornerRadius: 12)
        ]

        appendPopupsAndCheckCornerRadius(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: [.top: 12, .bottom: 0]
        )
    }
    func test_calculateCornerRadius_withPopupPadding_bottom_first() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, popupPadding: (top: 0, bottom: 12, horizontal: 0), cornerRadius: 1),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, cornerRadius: 12)
        ]

        appendPopupsAndCheckCornerRadius(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: [.top: 12, .bottom: 0]
        )
    }
    func test_calculateCornerRadius_withPopupPadding_bottom_last() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, cornerRadius: 1),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, popupPadding: (top: 0, bottom: 12, horizontal: 0), cornerRadius: 12)
        ]

        appendPopupsAndCheckCornerRadius(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: [.top: 12, .bottom: 12]
        )
    }
    func test_calculateCornerRadius_withPopupPadding_all() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, cornerRadius: 1),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300, popupPadding: (top: 12, bottom: 12, horizontal: 24), cornerRadius: 12)
        ]

        appendPopupsAndCheckCornerRadius(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: [.top: 12, .bottom: 12]
        )
    }
    func test_calculateCornerRadius_fullscreen() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: 300, cornerRadius: 13)
        ]

        appendPopupsAndCheckCornerRadius(
            popups: popups,
            gestureTranslation: 0,
            expectedValue: [.top: 0, .bottom: 0]
        )
    }
}

// MARK: Calculating Scale X
extension PopupBottomStackViewModelTests {
    func test_calculateScaleX_withNoGestureTranslation_threePopupsStacked_last() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 120),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 360)
        ]

        appendPopupsAndCheckScaleX(
            popups: popups,
            gestureTranslation: 0,
            calculateForIndex: 2,
            expectedValue: 1
        )
    }
    func test_calculateScaleX_withNoGestureTranslation_fourPopupsStacked_second() {
        let popups = [
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 300),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 120),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 360),
            createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 1360)
        ]

        appendPopupsAndCheckScaleX(
            popups: popups,
            gestureTranslation: 0,
            calculateForIndex: 1,
            expectedValue: 1 - testHook.stackScaleFactor * 2
        )
    }
    func test_calculateScaleX_withNegativeGestureTranslation_fourPopupsStacked_third() {

    }
    func test_calculateScaleX_withPositiveGestureTranslation_fivePopupsStacked_second() {

    }
}

// MARK: Calculating Fixed Size
extension PopupBottomStackViewModelTests {
    // auto mniejsze od screen
    // auto większe od screen
    // large
    // fullscreen
    // auto z gesture translation
}

// MARK: Calculating Stack Overlay Opacity
extension PopupBottomStackViewModelTests {
    // trzy na liscie, ostatni
    // cztery na liscie, ostatni z gesture ujemnym
    // piec na lisice, ostatni z gesture dodatnim
    // cztery na liscie, drugi
    // trzy na liscie, pierwszy z gesture translation
    // trzy na liscie, drugi z gesture translation
}


// fullscreen z popup padding HEIGHT
// large z popup padding HEIGHT






private extension PopupBottomStackViewModelTests {
    func appendPopupsAndPerformChecks<Value: Equatable>(popups: [AnyPopup], gestureTranslation: CGFloat, calculatedValue: @escaping (CGFloat?) -> (Value), expectedValue: Value) {
        viewModel.popups = popups
        viewModel.popups = recalculatePopupHeights()
        viewModel.gestureTranslation = gestureTranslation

        let expect = expectation(description: "results")
        viewModel.$activePopupHeight
            .receive(on: RunLoop.main)
            .dropFirst(3)
            .sink {
                XCTAssertEqual(calculatedValue($0), expectedValue)
                expect.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expect], timeout: 3)
    }

    func appendPopupsAndCheckScaleX(popups: [AnyPopup], gestureTranslation: CGFloat, calculateForIndex index: Int, expectedValue: CGFloat) {
        appendPopupsAndPerformChecks(
            popups: popups,
            gestureTranslation: gestureTranslation,
            calculatedValue: { [self] _ in testHook.calculateScaleX(for: viewModel.popups[index]) },
            expectedValue: expectedValue
        )
    }

    func appendPopupsAndCheckCornerRadius(popups: [AnyPopup], gestureTranslation: CGFloat, expectedValue: [MijickPopups.VerticalEdge: CGFloat]) {
        appendPopupsAndPerformChecks(
            popups: popups,
            gestureTranslation: gestureTranslation,
            calculatedValue: { [self] _ in testHook.calculateCornerRadius() },
            expectedValue: expectedValue
        )
    }

    func appendPopupsAndCheckTranslationProgress(popups: [AnyPopup], gestureTranslation: CGFloat, expectedValue: CGFloat) {
        appendPopupsAndPerformChecks(
            popups: popups,
            gestureTranslation: gestureTranslation,
            calculatedValue: { [self] _ in testHook.calculateTranslationProgress() },
            expectedValue: expectedValue
        )
    }


    func appendPopupsAndCheckBodyPadding(popups: [AnyPopup], gestureTranslation: CGFloat, expectedValue: EdgeInsets) {
        appendPopupsAndPerformChecks(
            popups: popups,
            gestureTranslation: gestureTranslation,
            calculatedValue: { [self] _ in testHook.calculateBodyPadding(for: popups.last!) },
            expectedValue: expectedValue
        )
    }
}


private extension PopupBottomStackViewModelTests {
    func appendPopupsAndCheckActivePopupHeight(popups: [AnyPopup], gestureTranslation: CGFloat, expectedValue: CGFloat) {
        appendPopupsAndPerformChecks(
            popups: popups,
            gestureTranslation: gestureTranslation,
            calculatedValue: { $0 },
            expectedValue: expectedValue
        )
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
    func createPopupInstanceForPopupHeightTests(heightMode: HeightMode, popupHeight: CGFloat, popupDragHeight: CGFloat? = nil, ignoredSafeAreaEdges: Edge.Set = [], popupPadding: (top: CGFloat, bottom: CGFloat, horizontal: CGFloat) = (0, 0, 0), cornerRadius: CGFloat = 0) -> AnyPopup {
        let config = getConfigForPopupHeightTests(heightMode: heightMode, ignoredSafeAreaEdges: ignoredSafeAreaEdges, popupPadding: popupPadding, cornerRadius: cornerRadius)

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
    func getConfigForPopupHeightTests(heightMode: HeightMode, ignoredSafeAreaEdges: Edge.Set, popupPadding: (top: CGFloat, bottom: CGFloat, horizontal: CGFloat), cornerRadius: CGFloat) -> Config { .init(
        cornerRadius: cornerRadius,
        ignoredSafeAreaEdges: ignoredSafeAreaEdges,
        heightMode: heightMode,
        popupPadding: popupPadding,
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
        safeArea: .init(top: 100, leading: 20, bottom: 50, trailing: 30)
    )}
}
