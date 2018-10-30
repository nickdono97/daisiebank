//
//  TransactionPresenter.swift
//  daisiebank
//
//  Created by Nick Donovan on 30/10/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import Foundation
protocol TransactionView {
    func startLoading()
    func finishLoading()
    func showTransactions(transactions:[Transaction])
    func showErrorAlert()
}
class TransactionPresenter {
    fileprivate let transactionManager:TransactionManager
    fileprivate var transactionView : TransactionView?
    
    init(transactionManager:TransactionManager){
        self.transactionManager = transactionManager
    }
    
    func attachView(_ view:TransactionView){
        self.transactionView = view
    }
    
    func detachView() {
        self.transactionView = nil
    }
    
    func getTransactions(){
        self.transactionView?.startLoading()
        self.transactionManager.getAllTransactions(onSuccess: { (jsonData) in
            let transactionObjects = try! JSONDecoder().decode(TransactionResult.self, from: jsonData)
            self.transactionView?.showTransactions(transactions: transactionObjects.transactions)
        }) { (errorMessage) in
            
        }
    }
}
