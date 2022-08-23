//
//  ChartViewModel.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 22/08/2022.
//

import Foundation
import Charts

class ChartViewModel {
    let apiService: ChartService

    var chartData: [ChartModel] = [ChartModel]() {
        didSet {
            self.processFetchedProducts(chartData: chartData)
        }
    }
    var yValues :[CandleChartDataEntry] = [CandleChartDataEntry]()
      
    private var candleDataViewModel: [CandelDataViewModel] = [CandelDataViewModel]() {
        didSet {
            for i in 0...candleDataViewModel.count - 1{
                yValues.append(CandleChartDataEntry(x: Double(i), shadowH: Double(candleDataViewModel[i].high) ?? 0.0, shadowL: Double(candleDataViewModel[i].low) ?? 0.0, open: Double(candleDataViewModel[i].openTime) ?? 0.0, close: Double(candleDataViewModel[i].closeTime) ?? 0.0))
            }
            self.viewChartClosure?()
        }
    }

    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var viewChartClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?

    init( apiService: ChartService = ChartServiceImpl()) {
        self.apiService = apiService
    }
    func initFetch(symbol: String, interval: String, limit: String) {
        state = .loading
        apiService.getChart(symbol: symbol , interval: interval, limit: limit) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
             self.chartData = data
              self.state = .populated
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.errorDescription
                    return
            }

        }
    }
    private func processFetchedProducts( chartData: [ChartModel] ) {
        self.candleDataViewModel = chartData.compactMap { CandelDataViewModel(data: $0) }
    
    }
    func logChartPageAnalytics(symbol: String){
        LogEventByFBAnalytics(name: "IOS: Chart Screen", contentType: "IOS: \(symbol) Chart Opened")
    }
}
