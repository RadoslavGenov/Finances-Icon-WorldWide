//
//  ExpenseTableViewController.swift
//  Finances
//
//  Created by Radoka on 4/6/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit
import CoreData

class ExpenseTableViewController: FetchedResultsTableViewController {
    
    private var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<Expense>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI(){
        if let context = container?.viewContext {
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController<Expense>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Expense", for: indexPath)
        
        if let expense = fetchedResultsController?.object(at: indexPath) {
            if let expenseCell = cell as? ExpenseTableViewCell {
                expenseCell.expense = expense
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expense = fetchedResultsController?.object(at: indexPath)
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheetController.addAction(cancelActionButton)
        
        let editActionButton = UIAlertAction(title: "Edit", style: .default)
        { [weak self] _ in
            self?.editExpense(expense)
        }
        actionSheetController.addAction(editActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Delete", style: .default)
        { [weak self] _ in
            self?.fetchedResultsController?.managedObjectContext.delete(expense!)
        }
        actionSheetController.addAction(deleteActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
        try? fetchedResultsController?.managedObjectContext.save()
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func editExpense(_ expense: Expense?){
        let alertController = UIAlertController(title: "Edit New Expense", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter New Title"
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter New Price"
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (alert) in
            expense!.title = (alertController.textFields![0] as UITextField).text
            expense!.price = Double((alertController.textFields![1] as UITextField).text!)!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true,completion: nil)
    }
    
    @objc func addExpense(_ sender: UIBarButtonItem!){
        let alertController = UIAlertController(title: "Add New Expense", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Title"
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Price"
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] (alert) in
            let title = alertController.textFields![0] as UITextField
            let price = alertController.textFields![1] as UITextField
            self?.add(withTitle: title.text!, withPrice: Double(price.text!)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true,completion: nil)
    }
    
    private func add(withTitle title: String, withPrice price: Double){
        let context = fetchedResultsController?.managedObjectContext
        _ = Expense.addExpense(withTitle: title, withPrice: price, in: context!)
        try? fetchedResultsController?.managedObjectContext.save()
    }
}
