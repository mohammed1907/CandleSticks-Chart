//
//  Config.swift
//  CandleSticks-Chart
//
//  Created by Mohamed Farghaly on 20/08/2022.
//

import Foundation

struct Config {
    static let baseURL: String = "https://fapi.binance.com/fapi/v1/"

    struct EndpointPath {
        static let getSticksLines = "klines"
    }
}
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}
