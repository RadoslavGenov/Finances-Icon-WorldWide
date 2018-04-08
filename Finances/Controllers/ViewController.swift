//
//  ViewController.swift
//  Finances
//
//  Created by Radoka on 4/5/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printDatabase(){
        if let context = container?.viewContext {
            context.perform {
                if let expense = try? context.count(for: Expense.fetchRequest()) {
                    print(expense)
                }
            }
        }
    }
    
    func updateDatabase(withTitle title: String, withPrice price: Double){
        container?.performBackgroundTask { context in
            _ = Expense.addExpense(withTitle: title, withPrice: price, in: context)
            try? context.save()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

