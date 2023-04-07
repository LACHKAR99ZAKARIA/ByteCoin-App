//
//  CoinModel.swift
//  ByteCoin
//
//  Created by zakaria lachkar on 3/13/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
    var rateString : String{
        return String(format: "%.2f", self.rate)
    }
}
