//
//  Coordinator.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 20/08/2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
