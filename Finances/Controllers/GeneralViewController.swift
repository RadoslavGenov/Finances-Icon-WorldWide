//
//  ViewController.swift
//  Finances
//
//  Created by Radoka on 4/5/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit
import CoreData

class GeneralViewController: UIViewController {
    
    private var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var currentIncome: UILabel!
    @IBOutlet weak var currentExpenses: UILabel!
    
    @IBOutlet weak var lastMonthBalance: UILabel!
    @IBOutlet weak var lastMonthExpenses: UILabel!
    @IBOutlet weak var lastMonthIncome: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI(){
        var expenses: [Expense]?
        var income: [Income]?
        
        if let context = container?.viewContext {
            if let exp = try? context.fetch(Expense.fetchRequest()) {
                expenses = exp as? [Expense]
            }
            if let inc = try? context.fetch(Income.fetchRequest()) {
                income = inc as? [Income]
            }
        }
    
        if !(income?.isEmpty)! || !(expenses?.isEmpty)! {
            let values = calculateBalance(expenses: expenses, income: income)
            currentExpenses.text = values.0
            currentIncome.text = values.1
            currentBalance.text = values.2
        } else {
            currentExpenses.text = NSLocalizedString("No Data", comment: "")
            currentIncome.text = NSLocalizedString("No Data", comment: "")
            currentBalance.text = NSLocalizedString("No Data", comment: "")
        }
        
        if let context = container?.viewContext{
            if let lastMonthExpense = try? Expense.getLastMonth(in: context) {
                expenses = lastMonthExpense
            }
            if let lastMonthIncome = try? Income.getLastMonth(in: context) {
                income = lastMonthIncome
            }
        }
        
        if !(income?.isEmpty)! || !(expenses?.isEmpty)! {
            let values = calculateBalance(expenses: expenses, income: income)
            lastMonthExpenses.text = values.0
            lastMonthIncome.text = values.1
            lastMonthBalance.text = values.2
        } else {
            lastMonthExpenses.text = NSLocalizedString("No Data", comment: "")
            lastMonthIncome.text = NSLocalizedString("No Data", comment: "")
            lastMonthBalance.text = NSLocalizedString("No Data", comment: "")
        }
    }
    
    private func calculateBalance(expenses: [Expense]?, income:  [Income]?) -> (String, String, String) {
        var sumExpense = 0.0
        var sumIncome = 0.0
        
        for e in expenses! {
            sumExpense += e.price
        }
        
        for i in income! {
            sumIncome += i.price
        }
        
        return (String(sumExpense), String(sumIncome), String(sumIncome - sumExpense))
    }
}

