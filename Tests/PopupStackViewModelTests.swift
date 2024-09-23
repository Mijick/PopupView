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
    func test_calculatePopupHeight_withAutoHeightMode_whenLessThanScreen() {
        let popup = createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: 100)
        viewModel.popups.append(popup)

        let calculatedPopupHeight = viewModel.testHook.calculatePopupHeight()
        let expectedPopupHeight = 100.0
        XCTAssertEqual(calculatedPopupHeight, expectedPopupHeight)
    }
    func test_calculatePopupHeight_withAutoHeightMode_whenLargerThanScreen() {
        let popup = createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: screen.height + 100)
        viewModel.popups.append(popup)

        let calculatedPopupHeight = viewModel.testHook.calculatePopupHeight()
        let expectedPopupHeight = screen.height
        XCTAssertEqual(calculatedPopupHeight, expectedPopupHeight)
    }






    func test_calculatePopupHeight_withAutoHeightMode_infinity() {
        let popup = createPopupInstanceForPopupHeightTests(heightMode: .auto, popupHeight: .infinity)



    }
    func test_calculatePopupHeight_withLargeHeightMode() {
        let popup = createPopupInstanceForPopupHeightTests(heightMode: .large, popupHeight: .infinity)
    }
    func test_calculatePopupHeight_withFullscreenMode() {
        let popup = createPopupInstanceForPopupHeightTests(heightMode: .fullscreen, popupHeight: .infinity)
    }
}
private extension PopupStackViewModelTests {
    func createPopupInstanceForPopupHeightTests(heightMode: HeightMode, popupHeight: CGFloat) -> AnyPopup {
        let config = getConfigForPopupHeightTests(heightMode: heightMode)

        var popup = AnyPopup(config: config)
        popup.height = popupHeight
        return popup
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

// MARK:




fileprivate typealias Config = LocalConfig.Vertical











// MARK: Helpers
private extension PopupStackViewModelTests {
    var screen: ScreenProperties { .init(
        height: 1000,
        safeArea: .init(top: 100, leading: 0, bottom: 50, trailing: 0)
    )}
}
