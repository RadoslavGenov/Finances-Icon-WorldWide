//
//  Expense.swift
//  Finances
//
//  Created by Radoka on 4/5/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit
import CoreData

class Expense: NSManagedObject {
    class func addExpense(withTitle title: String, withPrice price: Double, in context: NSManagedObjectContext) -> Expense {
        let expense = Expense(context: context)
        expense.price = price
        expense.title = title
        return expense
    }
}
