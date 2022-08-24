//
//  ApiServiceMock.swift
//  CandleSticks-ChartTests
//
//  Created by Mohamed farghaly on 24/08/2022.
//

import Foundation
@testable import CandleSticks_Chart


class ApiServiceMock: ChartService {
    var isFetchDataCalled = false
    var completeData: [ChartModel] = [ChartModel]()
    var completeClosure: ((Result<[ChartModel], NetworkError>) -> Void)!

    func getChart(symbol: String, interval: String, limit: String, completion: @escaping (Result<[ChartModel], NetworkError>) -> Void) {
        isFetchDataCalled = true
        completeClosure = completion
    }
}
