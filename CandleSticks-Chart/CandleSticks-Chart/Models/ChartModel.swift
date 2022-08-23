//
//  ChartModel.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 21/08/2022.
//
import Foundation

struct ChartModel: Codable {
    var openTime: Int
    var open : String
    var high : String
    var low : String
    var volume: String
    var close : String
    var closeTime: Int
    var qAssetVolume : String
    var numberoftrades :Int
    var tbBAssetVolume : String
    var tbQAssetVolume : String
    var ignoreVal : String
}
