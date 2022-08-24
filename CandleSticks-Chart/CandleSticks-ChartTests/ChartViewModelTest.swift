//
//  ChartViewModelTest.swift
//  CandleSticks-ChartTests
//
//  Created by Mohamed farghaly on 24/08/2022.
//

import XCTest
@testable import CandleSticks_Chart

class ChartViewModelTest: XCTestCase {
    var sut: ChartViewModel!
    var apiServiceMock: ApiServiceMock!

    override func setUp() {
        super.setUp()
        apiServiceMock = ApiServiceMock()
        sut = ChartViewModel(apiService: apiServiceMock)
    }
    override func tearDown() {
        sut = nil
        apiServiceMock = nil
        super.tearDown()
    }
    func test_fetch_chart() {
        // Given
        apiServiceMock.completeData = [ChartModel]()

        // When
        sut.initFetch(symbol: "BTCUSDT", interval: "15m", limit: "100")

        // Assert
        XCTAssert(apiServiceMock!.isFetchDataCalled)
    }
    func test_loading_state_when_fetching() {
        // Given
        var state: State = .empty
        let expect = XCTestExpectation(description: "Loading state updated to populated")
        sut.updateLoadingStatus = { [weak sut] in
            state = sut!.state
            expect.fulfill()
        }
        // when fetching
        sut.initFetch(symbol: "BTCUSDT", interval: "15m", limit: "100")
        // Assert
        XCTAssertEqual(state, State.loading)
        wait(for: [expect], timeout: 1.0)
    }
}
