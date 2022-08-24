//
//  ApiServiceTest.swift
//  CandleSticks-ChartTests
//
//  Created by Mohamed farghaly on 24/08/2022.
//

import Foundation
@testable import CandleSticks_Chart
import XCTest

class APIServiceTests: XCTestCase {
    var sut: ChartServiceImpl?
    override func setUp() {
        super.setUp()
        sut = ChartServiceImpl()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_chart_data() {

        // Given A apiservice
        let sut = self.sut!

        // When fetch popular photo
        let expect = XCTestExpectation(description: "callback")

        sut.getChart(symbol: "BTCUSDT", interval: "15m", limit: "100") {[weak self] result in
            guard let self = self else {
                return
            }
            expect.fulfill()
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 20)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            self.wait(for: [expect], timeout: 3.1)
    }
}
}
