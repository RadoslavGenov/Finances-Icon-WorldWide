//
//  TableViewCell.swift
//  Finances
//
//  Created by Radoka on 4/6/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var expense: Expense? { didSet { updateUI() } }
    
    private func updateUI(){
        title?.text = expense?.title
        
        if let expensePrice = expense?.price {
            price?.text = String(expensePrice)
        }
    }
}
