//
//  CurrencyCellViewModel.swift
//  CandleSticks-Chart
//
//  Created by Mohamed farghaly on 20/08/2022.
//

import Foundation

struct CurrencyCellViewModel {
    let currencyTitle: String
    init(data: CurrencyModel) {
        self.currencyTitle = data.symbol
    }
}
