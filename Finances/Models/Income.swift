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
        income.createdAt = Date()
        return income
    }
    
    class func getLastMonth(in context: NSManagedObjectContext) throws -> [Income]?{
        let currentDate = Date()
        var dateComponents = DateComponents()
        
        dateComponents.month = -1
        let dateFrom = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        dateComponents.month = -2
        let dateTo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        request.predicate = NSPredicate(format: "(%@ <= createdAt AND createdAt <= %@)", dateFrom! as NSDate, dateTo! as NSDate)
        
        let matches = try? context.fetch(request)
        return matches
    }
}
