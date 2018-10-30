//
//  TransactionViewController.swift
//  daisiebank
//
//  Created by Nick Donovan on 30/10/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import UIKit
class TransactionViewController: UIViewController {
    fileprivate let transactionPresenter = TransactionPresenter(transactionManager: TransactionManager())
    fileprivate var tableData:[Transaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionPresenter.attachView(self)
        transactionPresenter.getTransactions()
    }
}
//MARK: - View Protocol Methods
extension TransactionViewController: TransactionView {
    func startLoading() {
        
    }
    func finishLoading() {
        
    }
    
    func showTransactions(transactions: [Transaction]) {
        
    }
    func showErrorAlert() {
        
    }
}
