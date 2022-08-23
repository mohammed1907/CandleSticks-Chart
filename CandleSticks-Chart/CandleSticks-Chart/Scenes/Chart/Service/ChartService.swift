//
//  ChartService.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 21/08/2022.
//

import Foundation

protocol ChartService {
    func getChart(symbol:String,interval:String,limit:String,completion: @escaping (Result<[ChartModel], NetworkError>) -> Void)
}

class ChartServiceImpl: ChartService {
    private let service = NetworkService()

    func getChart(symbol:String,interval:String,limit:String,completion: @escaping (Result<[ChartModel], NetworkError>) -> Void) {
        return service.fetchRequest(forRoute: .getSticksLines(symbol: symbol, interval: interval, limit: limit), completion: completion)
    }
}
