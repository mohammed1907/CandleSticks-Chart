//
//  CandelDataViewModel.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 22/08/2022.
//

import Foundation

struct CandelDataViewModel {
    let openTime : String
    let high : String
    let low : String
    let closeTime : String
    init(data: ChartModel) {
        self.openTime = data.open
        self.high = data.high
        self.low = data.low
        self.closeTime = data.close 
    }
}
