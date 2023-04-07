//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol coinDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinModel : CoinModel)
    func didFailWithError(error : Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "CE938230-B4A7-476A-856B-36D31C625C41"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate : coinDelegate?

    func getCoinPrice(for currency : String){
        if let urlString:String = "\(self.baseURL)/\(currency)?apiKey=\(self.apiKey)"{
            print(urlString)
            self.performRequest(with: urlString)
        }
    }
    
    func performRequest(with urlString: String)  {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data:Data?, urlResponse:URLResponse?, error:Error?) in
                if error != nil{
                    print(error)
                }
                if let safeData = data {
                    if let coins = self.parseJSON(cData: safeData){
                        self.delegate?.didUpdateCoin(self, coinModel: coins)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(cData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try  decoder.decode(CoinData.self, from: cData)
            let rate = decodedData.rate
            let assetBase = decodedData.asset_id_base
            let assetQuota = decodedData.asset_id_quote
            
            let coins = CoinModel(asset_id_base: assetBase, asset_id_quote: assetQuota, rate: rate)
            return coins
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}
