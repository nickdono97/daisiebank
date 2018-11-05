//
//  TransactionPresenter.swift
//  daisiebank
//
//  Created by Nick Donovan on 30/10/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import Foundation
import UIKit

protocol TransactionView {
    func startLoading()
    func finishLoading()
    func showTransactions(sections:[Date], transactionDict:[Date:[Transaction]])
    func showErrorAlert(errorMessage:String)
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
    
    //MARK: - Transaction getting and sorting methods
    //Get transactions from transaction model class. Start loading on view
    func getTransactions(){
        self.transactionView?.startLoading()
        self.transactionManager.getAllTransactions(onSuccess: { (jsonData) in
            let transactionObjects = try! JSONDecoder().decode(TransactionResult.self, from: jsonData)
            self.sortTransactions(transactions: transactionObjects.transactions)
        }) { (errorMessage) in
            self.transactionView?.showErrorAlert(errorMessage: errorMessage)
        }
    }
    //Method to get start of the day as date for transaction dict key
    func dateAtBeginningOfDay(inputDate:Date) -> Date {
        var calendar = Calendar.current
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        
        var dateComponents = calendar.dateComponents([.year,.month,.day], from: inputDate)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        let date = calendar.date(from: dateComponents)
        return date!
    }
    
    //Takes all transactions and sorts them into individual keys. Each key is a day. Each value for key contains the list of transactions for that day
    func sortTransactions(transactions:[Transaction]){
        let sortedTransactions = transactions.sorted(by: {$0.created > $1.created})
        var transactionsDict = [Date:[Transaction]]()
        
        sortedTransactions.forEach { (transaction) in
            let dateRepresentingDay = self.dateAtBeginningOfDay(inputDate: transaction.created)
            
            var transactionsOnDay = transactionsDict[dateRepresentingDay]
            if transactionsOnDay == nil{
                transactionsOnDay = []
                transactionsDict[dateRepresentingDay] = transactionsOnDay
            }
            transactionsOnDay?.append(transaction)
            transactionsDict[dateRepresentingDay] = transactionsOnDay
        }
        let sortedSectionArray = transactionsDict.keys.sorted(by: {$0 > $1})
        self.transactionView?.showTransactions(sections: sortedSectionArray, transactionDict: transactionsDict)
    }
    
    //MARK: - Transaction view data methods
    //Converts date to string for tableview header
    func formatDateString(date:Date)->String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale.init(identifier: "en_GB")
        
        let weekDay = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let dateString = "\(calendar.weekdaySymbols[weekDay]), \(day) \(calendar.standaloneMonthSymbols[month])"
        return dateString
    }
    
    //Converts pence amount to pounds with currency locale
    func convertPenceToPounds(pence:Int) -> String {
        let poundFloat = Float(pence/100)
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en_GB")
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: poundFloat.magnitude as NSNumber) {
            return formattedAmount
        }else{
            return ""
        }
    }
}
