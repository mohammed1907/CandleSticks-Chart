//
//  ViewController.swift
//  CandleSticks-Chart
//
//  Created by Mohamed Farghaly on 20/08/2022.
//

import UIKit

class CurrenciesViewController: UIViewController,Storyboarded {
    weak var coordinator: MainCoordinator?
    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: CurrenciesViewModel = {
        return CurrenciesViewModel()
    }()

 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.logCurrencyPageAnalytics()
    }
    func setupBindings() {
        // Native binding
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.currencies = [CurrencyModel(symbol:"BTC", interval: "15m", limit: "100"),CurrencyModel(symbol: "ETH" , interval: "30m", limit: "500"),CurrencyModel(symbol: "LTC", interval: "1h", limit: "1500")]

    }
    func setupUI() {
        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CurrencyTableViewCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
}

extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath)
                as? CurrencyTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.currencyCellViewModel = cellVM
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.getCurrencyData(at: indexPath)
        coordinator?.gotToChart(title: "\(data.symbol)/USDT", symbol: "\(data.symbol)USDT", interval: data.interval, limit: data.limit)
       
    }
}
