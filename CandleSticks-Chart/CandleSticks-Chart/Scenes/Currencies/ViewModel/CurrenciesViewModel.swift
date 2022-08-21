//
//  CurrenciesViewModel.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 20/08/2022.
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
}
