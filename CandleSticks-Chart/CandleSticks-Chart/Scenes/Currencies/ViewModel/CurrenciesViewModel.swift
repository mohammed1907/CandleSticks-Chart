//
//  CurrenciesViewModel.swift
//  CandleSticks-Chart
//
//  Created by Mohamed farghaly on 20/08/2022.
//

import Foundation

class CurrenciesViewModel {

    var currencies: [CurrencyModel] = [CurrencyModel]() {
        didSet {
            self.processFetchedProducts(data: currencies)
        }
    }
    private var cellViewModels: [CurrencyCellViewModel] = [CurrencyCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var reloadTableViewClosure: (() -> Void)?
    private func processFetchedProducts( data: [CurrencyModel] ) {
        self.cellViewModels = currencies.compactMap { CurrencyCellViewModel(data: $0) }
    }
    func getCellViewModel( at indexPath: IndexPath ) -> CurrencyCellViewModel {
        return cellViewModels[indexPath.row]
    }
    func getCurrencyData( at indexPath: IndexPath ) -> CurrencyModel {
        return currencies[indexPath.row]
    }
    func logCurrencyPageAnalytics(){
        LogEventByFBAnalytics(name: "IOS: Currency Screen", contentType: "IOS: Currency Screen Opened")
    }
}
