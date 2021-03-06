//
//  ExpenseTableViewController.swift
//  Finances
//
//  Created by Radoka on 4/6/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit
import CoreData

class ExpenseTableViewController: FetchedResultsTableViewController, UITextFieldDelegate {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Expense, for: indexPath)
        
        if let expense = fetchedResultsController?.object(at: indexPath) {
            if let expenseCell = cell as? ExpenseTableViewCell {
                expenseCell.expense = expense
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expense = fetchedResultsController?.object(at: indexPath)
        
        self.startAlert(expense)
        
        try? fetchedResultsController?.managedObjectContext.save()
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func addExpense(_ sender: UIBarButtonItem!){
        self.addExpense()
    }
    
    private func add(withTitle title: String, withPrice price: Double){
        let context = fetchedResultsController?.managedObjectContext
        _ = Expense.addExpense(withTitle: title, withPrice: price, in: context!)
        try? fetchedResultsController?.managedObjectContext.save()
    }
}

extension ExpenseTableViewController {
    private func editExpense(_ expense: Expense?){
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString("Edit Expense", comment: ""), message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = NSLocalizedString("Enter New Title", comment: "")
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = NSLocalizedString("Enter New Price", comment: "")
            textField.delegate = self
        })
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default, handler: { (alert) in
            let fieldTitle = (alertController.textFields![0] as UITextField).text
            let fieldPrice = (alertController.textFields![1] as UITextField).text
            // Check for empty fields
            if !((fieldTitle?.isEmpty)!) && !((fieldPrice?.isEmpty)!) {
                expense!.title = fieldTitle
                expense!.price = Double(fieldPrice!)!
            }
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: { (action) in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addExpense() {
        let alertController = UIAlertController(title: NSLocalizedString("Add New Expense", comment: ""), message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = NSLocalizedString("Enter Title", comment: "")
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = NSLocalizedString("Enter Price", comment: "")
            textField.delegate = self
        })
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default, handler: { [weak self] (alert) in
            let fieldTitle = (alertController.textFields![0] as UITextField).text
            let fieldPrice = (alertController.textFields![1] as UITextField).text
            // Check for empty fields
            if !((fieldTitle?.isEmpty)!) && !((fieldPrice?.isEmpty)!) {
                self?.add(withTitle: fieldTitle!, withPrice: Double(fieldPrice!)!)
            }
        })
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: { (action) in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func startAlert(_ expense: Expense?){
        
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Please Select", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        actionSheetController.addAction(cancelActionButton)
        
        let editActionButton = UIAlertAction(title: NSLocalizedString("Edit", comment: ""), style: .default)
        { [weak self] _ in
            self?.editExpense(expense)
        }
        actionSheetController.addAction(editActionButton)
        
        let deleteActionButton = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default)
        { [weak self] _ in
            self?.fetchedResultsController?.managedObjectContext.delete(expense!)
        }
        actionSheetController.addAction(deleteActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //textfield restriction
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
