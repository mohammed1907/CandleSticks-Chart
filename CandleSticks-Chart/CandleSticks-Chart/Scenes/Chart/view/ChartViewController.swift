//
//  ChartViewController.swift
//  CandleSticks-Chart
//
//  Created by Mohamed farghaly on 21/08/2022.
//

import UIKit
import Charts
import TinyConstraints
class ChartViewController: UIViewController ,Storyboarded {
    weak var coordinator: MainCoordinator?
    var chartStringTitle: String?
    var symbol: String?
    var interval: String?
    var limit: String?

    @IBOutlet weak var chartTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    lazy var viewModel: ChartViewModel = {
        return ChartViewModel()
    }()
    lazy var candleChartView: CandleStickChartView = {
        return viewModel.setupChartView()
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.logChartPageAnalytics(symbol: symbol ?? "")
    }
    func setData(data: [CandleChartDataEntry]){
        let set1 = CandleChartDataSet(data)
        set1.formLineWidth = 4
        
        let data = CandleChartData(dataSet: set1)
        data.setDrawValues(false)
        candleChartView.data = data
        candleChartView.leftAxis.axisMaximum = viewModel.maxValue ?? 0.0
        candleChartView.leftAxis.axisMinimum = viewModel.miniValue ?? 0.0
    }
  
    func initView() {
        chartTitle.text = chartStringTitle
        containerView.addSubview(candleChartView)
        candleChartView.centerInSuperview()
        candleChartView.width(to: containerView)
        candleChartView.heightToWidth(of: containerView)
        navigationController?.isNavigationBarHidden = true
    }
    func initVM() {
        // Native binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }

        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty, .error:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.containerView.alpha = 0.0
                    })
                case .loading:
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.containerView.alpha = 0.0
                    })
                case .populated:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.containerView.alpha = 1.0
                    })
                }
            }
        }

        viewModel.viewChartClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.setData(data: self?.viewModel.yValues ?? [])
            }
        }
        viewModel.initFetch(symbol: self.symbol ?? "", interval: self.interval ?? "", limit: self.limit ?? "")

    }
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChartViewController: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
