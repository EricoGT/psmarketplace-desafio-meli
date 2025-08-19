//
//  SearchProductResult.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

public struct SearchProductResult: Decodable {
    let query: String
    let results: [ProductData]
}
