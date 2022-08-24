//
//  ChartModel.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 21/08/2022.
//
import Foundation

struct ChartModel: Decodable {
    let result: [Any]
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let openTime = try container.decode(Int.self)
        let open = try container.decode(String.self)
        let high = try container.decode(String.self)
        let low = try container.decode(String.self)
        let volume = try container.decode(String.self)
        let close = try container.decode(String.self)
        let closeTime = try container.decode(Int.self)
        let qAssetVolume = try container.decode(String.self)
        let numberoftrades = try container.decode(Int.self)
        let tbBAssetVolume = try container.decode(String.self)
        let tbQAssetVolume = try container.decode(String.self)
        let ignoreVal = try container.decode(String.self)
        result = [openTime, open, high, low ,
                  volume, close, closeTime, qAssetVolume,
                  numberoftrades, tbBAssetVolume, tbQAssetVolume, ignoreVal]
    }
}
