//
//  PageViewController.swift
//  Finances
//
//  Created by Radoka on 4/6/18.
//  Copyright © 2018 radoslav.genov.1992. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    private var arrayIndex: Int = 0
    
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: Identifiers.Expense),
            self.getViewController(withIdentifier: Identifiers.General),
            self.getViewController(withIdentifier: Identifiers.Income)
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate   = self
        
        self.navigationController!.navigationBar.barTintColor = UIColor.blue
        self.navigationItem.title = NSLocalizedString(Identifiers.General, comment: "")

        setViewControllers([pages[1]], direction: .forward, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) {
            return
        }
        
        if let firstViewController = viewControllers?.first,
            let arrayIndex = pages.index(of: firstViewController) {
            switch arrayIndex {
            case 0:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .plain, target: pages[0], action: #selector(ExpenseTableViewController.addExpense(_:)))
                self.navigationController!.navigationBar.topItem!.title = NSLocalizedString(Identifiers.Expense, comment: "")
                self.navigationController!.navigationBar.barTintColor = UIColor.red
                break
            case 1:
                self.navigationItem.rightBarButtonItem = nil
                self.navigationController!.navigationBar.topItem!.title = NSLocalizedString(Identifiers.General, comment: "")
                self.navigationController!.navigationBar.barTintColor = UIColor.blue
                break
            case 2:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add", comment: ""), style: .plain, target: pages[2], action: #selector(IncomeTableViewController.addIncome(_:)))
                self.navigationController!.navigationBar.topItem!.title = NSLocalizedString(Identifiers.Income, comment: "")
                self.navigationController!.navigationBar.barTintColor = UIColor.green
                break
            default:
                break
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
}


