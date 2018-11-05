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
    let created:Date
    let settled:Date
    let notes:String
    
     init(from decoder: Decoder) throws {
        //Set up json parsing from API
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        amount = try container.decode(Int.self, forKey: .amount)
        currency = try container.decode(String.self, forKey: .currency)
        merchant = try container.decode(Merchant.self, forKey: .merchant)
        description = try container.decode(String.self, forKey: .description)
        notes = try container.decode(String.self, forKey: .notes)
        
        //Set up date formatter for decode
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        //Parse created date string to date from server
        let createdString = try container.decode(String.self, forKey: .created)
        if let createdDate = dateFormatter.date(from: createdString){
            created = createdDate
        }else{
            throw DecodingError.dataCorruptedError(forKey: .created,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        //Parse settled date string to date from server
        let settledString = try container.decode(String.self, forKey: .settled)
        if let settledDate = dateFormatter.date(from: settledString){
            settled = settledDate
        }else{
            throw DecodingError.dataCorruptedError(forKey: .settled,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

struct Merchant:Codable {
    let id:String
//    let address:Address
    let name:String
    let category:String
    let logo:URL
    let created:Date
    
    //Set up JSON parsing from server
    init(from decoder: Decoder) throws {
        //Set up json parsing from API
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
//        address = try container.decode(Address.self, forKey: .address)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        
        //Parse merchant logo url string into URL
        let logoString = try container.decode(String.self, forKey: .logo)
        if let logoUrl = URL.init(string: logoString){
            logo = logoUrl
        }else{
            throw DecodingError.dataCorruptedError(forKey: .logo,
                                                   in: container,
                                                   debugDescription: "URL string does not match format for URL object")
        }
        //Set up date formatter for decode
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        //Parse created date string to date from server
        let createdString = try container.decode(String.self, forKey: .created)
        if let createdDate = dateFormatter.date(from: createdString){
            created = createdDate
        }else{
            throw DecodingError.dataCorruptedError(forKey: .created,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        
    }
}
struct Address:Codable {
    //This does not need parsing due to correct object type and property names
//    let address:String
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
    
    /// Get image of merchant for transaction
    ///
    /// - Parameters:
    ///   - imageURL: Merchant logo image url
    ///   - successCallback: successful request returns encoded image data
    ///   - failureCallback: failing request sends message to presenter to show default image
    func getTransactionImage(imageURL:URL,
                             onSuccess successCallback: @escaping ((_ transactions: Data) -> Void),
                             onFailure failureCallback: @escaping ((_ errorMessage: String) -> Void)){
        
        var imageRequest = URLRequest.init(url: imageURL)
        imageRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: imageRequest) { (imageData, urlResponse, error) in
            //Check status code of request
            let httpResponse = urlResponse as? HTTPURLResponse
            if httpResponse?.statusCode == 200{
                guard let imageData = imageData else {return}
                //Return image data
                successCallback(imageData)
            }else{
                //Error back from server
                failureCallback("Error getting image")
            }
        }.resume()
    }
}

