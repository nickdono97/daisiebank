//
//  TransactionViewController.swift
//  daisiebank
//
//  Created by Nick Donovan on 30/10/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import UIKit
class TransactionTableViewCell: UITableViewCell {
    @IBOutlet var merchantImageView: UIImageView!
    @IBOutlet var merchantNameLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
}


class TransactionViewController: UIViewController{
    //MARK: - View controller properties
    //IBOutlets decleration
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    //Class properties
    fileprivate let transactionPresenter = TransactionPresenter(transactionManager: TransactionManager())
    fileprivate var sectionTitles:[Date]?
    fileprivate var transactionDict:[Date:[Transaction]]?
    
    //Init view from storyboard file method
     static func storyboardInstance() -> TransactionViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? TransactionViewController
    }
    
    //MARK: - View controller initial methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.balanceLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.medium)
        self.balanceLabel.textColor = UIColor.darkGray
        self.balanceLabel.text = "Balance:  £7.00"
        
        transactionPresenter.attachView(self)
        transactionPresenter.getTransactions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        transactionPresenter.detachView()
    }
}

//MARK: - Tableview data source and delegate methods
extension TransactionViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = self.sectionTitles?[section]
        let dateString = self.transactionPresenter.formatDateString(date: date ?? Date())
        return dateString
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = self.sectionTitles?[section]
        let transactionArray = transactionDict?[sectionKey ?? Date()]
        return transactionArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TransactionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionTableViewCell
        let sectionKey = self.sectionTitles?[indexPath.section]
        let transactionArray = transactionDict?[sectionKey ?? Date()]
        let transaction = transactionArray?[indexPath.row]
        cell.merchantNameLabel.text = transaction?.merchant.name
        cell.costLabel.text = transactionPresenter.convertPenceToPounds(pence: transaction?.amount ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - View Protocol Methods
extension TransactionViewController: TransactionView {
    func showTransactions(sections: [Date], transactionDict: [Date : [Transaction]]) {
        print("SHOW TRANSACTIONS")
        self.sectionTitles = sections
        self.transactionDict = transactionDict
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func startLoading() {
        //Start progress indicator
    }
    func finishLoading() {
        //Stop progress indidctor
    }
    
    func showErrorAlert(errorMessage:String) {
        let alertController = UIAlertController.init(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}
