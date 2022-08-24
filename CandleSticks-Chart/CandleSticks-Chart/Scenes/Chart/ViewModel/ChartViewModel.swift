//
//  ChartViewModel.swift
//  CandleSticks-Chart
//
//  Created by Mohamed farghaly on 22/08/2022.
//

import Foundation
import Charts

class ChartViewModel {
    let apiService: ChartService

    var chartData: [ChartModel] = [ChartModel]() {
        didSet {
            self.processFetchedValues(chartData: chartData)
        }
    }
    var yValues :[CandleChartDataEntry] = [CandleChartDataEntry]()
    var miniValue: Double?
    var maxValue: Double?
    private var chartValues: [[String]] = [[String]]() {
        didSet {
            print("chart values ->>> ", chartValues)
            maxValue = chartValues.max(by: {$0.first! < $1.first!})?.map{Double($0)!}.max()
            miniValue = chartValues.min(by: {$0.first! < $1.first!})?.map{Double($0)!}.min()
            for i in 0...chartValues.count - 1{
                yValues.append(CandleChartDataEntry(x: Double(i), shadowH: Double(chartValues[i][0]) ?? 0.0, shadowL: Double(chartValues[i][1]) ?? 0.0, open: Double(chartValues[i][2]) ?? 0.0, close:Double(chartValues[i][3]) ?? 0.0))
            
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
    private func processFetchedValues(chartData: [ChartModel]?) {
        guard let list = chartData else {
            return
        }
        var chartValues: [[Any]] = []
        list.forEach({ values in
            chartValues.append(values.result)
        })
        
        self.chartValues = chartValues.map{Array($0.filter{return $0 is String}.prefix(4))} as? [[String]] ?? [[]]
        print("chart values ->>>",  self.chartValues)
    }
    func setupChartView() -> CandleStickChartView{
        let chartView = CandleStickChartView()
        chartView.backgroundColor = UIColor(displayP3Red: 49/255, green: 49/255, blue: 49/255, alpha: 1)
        chartView.rightAxis.enabled = false
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        leftAxis.setLabelCount(6, force: false)
        leftAxis.labelTextColor = .white
        leftAxis.axisLineColor = .white
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisMinimum = 0.0
        chartView.xAxis.axisMaximum = 90.0
        let rightAxis = chartView.rightAxis
        rightAxis.labelFont = .boldSystemFont(ofSize: 12)
        rightAxis.setLabelCount(6, force: false)
        rightAxis.labelTextColor = .white
        rightAxis.axisLineColor = .white
        return chartView
    }
    func logChartPageAnalytics(symbol: String){
        LogEventByFBAnalytics(name: "IOS: Chart Screen", contentType: "IOS: \(symbol) Chart Opened")
    }
}
