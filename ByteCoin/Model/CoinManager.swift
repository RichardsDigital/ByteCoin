//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func createURL(selectedLocation: String) {
        let bindedURL = baseURL + selectedLocation
        performRequest(bindedURL: bindedURL)
    }
    
    func performRequest(bindedURL: String) {
        // Create a URL
        if let url = URL(string: bindedURL) {
            // Create a URL session
            let session = URLSession(configuration: .default)
            // Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("error!")
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(bitcoinData: safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    func parseJSON(bitcoinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(BitcoinData.self, from: bitcoinData)
            let lastPrice = decodedData.last
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
