//
//  IncomeTableViewController.swift
//  Finances
//
//  Created by Radoka on 4/6/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit
import CoreData

class IncomeTableViewController: FetchedResultsTableViewController, UITextFieldDelegate {
    
    private var  container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<Income>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI(){
        if let context = container?.viewContext {
            let request: NSFetchRequest<Income> = Income.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController<Income>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Income, for: indexPath)
        
        if let income = fetchedResultsController?.object(at: indexPath) {
            if let incomeCell = cell as? IncomeTableViewCell {
                incomeCell.income = income
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let income = fetchedResultsController?.object(at: indexPath)
        
        self.startAlert(income)
        
        try? fetchedResultsController?.managedObjectContext.save()
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func addIncome(_ sender: UIBarButtonItem!){
        self.addIncome()
    }
    
    private func add(withTitle title: String, withPrice price: Double){
        let context = fetchedResultsController?.managedObjectContext
        _ = Income.addIncome(withTitle: title, withPrice: price, in: context!)
        try? fetchedResultsController?.managedObjectContext.save()
    }
}

extension IncomeTableViewController {
    private func editIncome(_ income: Income?){
        let alertController: UIAlertController = UIAlertController(title: "Edit Income", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter New Title"
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter New Price"
            textField.delegate = self
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (alert) in
            income!.title = (alertController.textFields![0] as UITextField).text
            income!.price = Double((alertController.textFields![1] as UITextField).text!)!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addIncome() {
        let alertController = UIAlertController(title: "Add New Income", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Title"
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Price"
            textField.delegate = self
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] (alert) in
            let title = alertController.textFields![0] as UITextField
            let price = alertController.textFields![1] as UITextField
            self?.add(withTitle: title.text!, withPrice: Double(price.text!)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func startAlert(_ income: Income?){
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheetController.addAction(cancelActionButton)
        
        let editActionButton = UIAlertAction(title: "Edit", style: .default)
        { [weak self] _ in
            self?.editIncome(income)
        }
        actionSheetController.addAction(editActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Delete", style: .default)
        { [weak self] _ in
            self?.fetchedResultsController?.managedObjectContext.delete(income!)
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

