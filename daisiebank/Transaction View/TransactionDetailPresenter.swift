//
//  TransactionDetailPresenter.swift
//  daisiebank
//
//  Created by Nick Donovan on 05/11/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import Foundation
import UIKit

protocol TransactionDetailView {
//    func startLoading()
//    func finishLoading()
//    func showTransactions(sections:[Date], transactionDict:[Date:[Transaction]])
//    func showErrorAlert(errorMessage:String)
}
class TransactionDetailPresenter{
    fileprivate let transactionManager:TransactionManager
    fileprivate var transactionDetailView : TransactionView?
    
    init(transactionManager:TransactionManager){
        self.transactionManager = transactionManager
    }
    
    func attachView(_ view:TransactionView){
        self.transactionDetailView = view
    }
    
    func detachView() {
        self.transactionDetailView = nil
    }
    
    
}
