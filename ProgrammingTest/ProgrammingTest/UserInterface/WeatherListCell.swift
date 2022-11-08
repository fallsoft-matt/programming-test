//
//  WeatherListCell.swift
//  ProgrammingTest
//
//  Created by Matthew Faller on 10/11/22.
//

import Foundation
import UIKit

class WeatherListCell: UITableViewCell {
    
    @IBOutlet private weak var airportCode: UILabel!
    @IBOutlet private weak var visibility: UILabel!
    @IBOutlet private weak var flightRules: UILabel!
    
    public var model: WeatherReport? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        airportCode.text = model?.ident.uppercased() ?? "-"
        visibility.text = model?.visibility
        flightRules.text = model?.flightRules ?? "-"
    }
}
