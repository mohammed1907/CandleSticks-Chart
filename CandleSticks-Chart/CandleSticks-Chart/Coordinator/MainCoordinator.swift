//
//  MainCoordinator.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 20/08/2022.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = CurrenciesViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    func gotToChart(title:String,symbol:String,interval:String,limit:String) {
        let vc = ChartViewController.instantiate()
        vc.coordinator = self
        vc.chartStringTitle = title
        vc.symbol = symbol
        vc.interval = interval
        vc.limit = limit
        navigationController.pushViewController(vc, animated: false)
    }
}
