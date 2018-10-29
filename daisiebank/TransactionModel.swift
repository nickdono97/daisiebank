//
//  TransactionModel.swift
//  daisiebank
//
//  Created by Nick Donovan on 29/10/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import Foundation
class TransactionManager {
    //MARK: - Transaction strucs
    struct Transaction {
        let id:String
        let amount:Int
        let currency:String
        let merchant:Merchant
        let description:String
        let created:Date
        let settled:Date
        let notes:String
    }
    
    struct Merchant {
        let id:String
        let address:Address
        let name:String
        let category:String
        let logo:URL
        let created:Date
    }
    
    struct Address {
        let street:String
        let city:String
        let country:String
        let latitude:Float
        let longitude:Float
        let postCode: String
        let region:String
    }
    class var sharedInstance: TransactionManager {
        struct Singleton {
            static let instance = TransactionManager()
        }
        return Singleton.instance
    }
    //MARK: - Transaction methods
    
    
    /// Get all transactions from backend
    ///
    /// - Parameters:
    ///   - successCallback: successful request returns JSON data as Data
    ///   - failureCallback: failing request returns error message as String
    func getAllTransactions(onSuccess successCallback: @escaping ((_ transactions: Data) -> Void),
                            onFailure failureCallback: @escaping ((_ errorMessage: String) -> Void)){
        
        if let transactionUrl = URL.init(string: "https://daisie-ios.glitch.me/transactions"){
            var transactionRequest:URLRequest = URLRequest.init(url: transactionUrl)
            transactionRequest.httpMethod = "GET"
            URLSession.shared.dataTask(with: transactionRequest) { (jsonData, urlResponse, error) in
                let httpResponse = urlResponse as? HTTPURLResponse
                if httpResponse?.statusCode == 200{
                    if let jsonData = jsonData{
                        successCallback(jsonData)
                    }
                }else{
                    failureCallback(String(format: "Backend error - Status code: %d", httpResponse?.statusCode ?? 0))
                }
                failureCallback("URL error - URL not avaliable")
            }
        }
    }
}

