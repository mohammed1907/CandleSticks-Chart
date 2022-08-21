//
//  CurrencyTableViewCell.swift
//  CandleSticks-Chart
//
//  Created by Omar Hassanein on 20/08/2022.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyName: UILabel!
    var currencyCellViewModel: CurrencyCellViewModel? {
        didSet {
            currencyName.text = currencyCellViewModel?.currencyTitle
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none

    }
    
}
