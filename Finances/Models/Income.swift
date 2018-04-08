//
//  Income.swift
//  Finances
//
//  Created by Radoka on 4/5/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit
import CoreData

class Income: NSManagedObject {
    class func addIncome(withTitle title: String, withPrice price: Double, in context: NSManagedObjectContext) -> Income {
        let income = Income(context: context)
        income.price = price
        income.title = title
        return income
    }
}
