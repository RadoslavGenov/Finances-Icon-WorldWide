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
        expense.createdAt = Date()
        return expense
    }
    
    class func getLastMonth(in context: NSManagedObjectContext) throws -> [Expense]?{
        let currentDate = Date()
        var dateComponents = DateComponents()
        
        dateComponents.month = -1
        let dateFrom = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        dateComponents.month = -2
        let dateTo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "(%@ <= createdAt AND createdAt <= %@)", dateFrom! as NSDate, dateTo! as NSDate)
        
        let matches = try? context.fetch(request)
        return matches
    }
}
