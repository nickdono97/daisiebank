//
//  TransactionModel.swift
//  daisiebank
//
//  Created by Nick Donovan on 29/10/2018.
//  Copyright © 2018 nickdonovan. All rights reserved.
//

import Foundation
//MARK: - Transaction strucs
struct TransactionResult:Codable {
    let transactions:[Transaction]
}

struct Transaction:Codable {
    let id:String
    let amount:Int
    let currency:String
    let merchant:Merchant
    let description:String
    let created:String
    let settled:String
    let notes:String
}

struct Merchant:Codable {
    let id:String
//    let address:Address
    let name:String
    let category:String
    let logo:URL
    let created:String

}

struct Address:Codable {
    let address:String
    let city:String
    let country:String
    let latitude:Float
    let longitude:Float
    let postcode: String
    let region:String
}

//MARK: - Transaction manager
class TransactionManager {
    /// Get all transactions from backend
    ///
    /// - Parameters:
    ///   - successCallback: successful request returns JSON data as Data
    ///   - failureCallback: failing request returns error message as String
    func getAllTransactions(onSuccess successCallback: @escaping ((_ transactions: Data) -> Void),
                            onFailure failureCallback: @escaping ((_ errorMessage: String) -> Void)){
        guard let transactionUrl = URL.init(string: "https://daisie-ios.glitch.me/transactions") else {return}
        var transactionRequest:URLRequest = URLRequest.init(url: transactionUrl)
        transactionRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: transactionRequest) { (jsonData, urlResponse, error) in
            //Return HTTP response from server - check status code is OK
            let httpResponse = urlResponse as? HTTPURLResponse
            if httpResponse?.statusCode == 200{
                guard let jsonData = jsonData else {return}
                    //Return JSON data
                    successCallback(jsonData)
            }else{
                //Request or server error return status code
                failureCallback(String(format: "Backend error - Status code: %d", httpResponse?.statusCode ?? 0))
            }
        }.resume()
    }
}

