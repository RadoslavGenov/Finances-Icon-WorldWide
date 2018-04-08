//
//  IncomeTableViewCell.swift
//  Finances
//
//  Created by Radoka on 4/6/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit

class IncomeTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var income: Income? { didSet { updateUI() } }
    
    private func updateUI(){
        title?.text = income?.title
        
        if let incomePrice = income?.price {
            price?.text = String(incomePrice)
        }
    }
}
