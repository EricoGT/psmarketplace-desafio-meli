//
//  ProductAttributes.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

public struct ProductAttributes: Decodable {
    let id: String
    let name: String
    let valueName: String?
    
    private enum CodingKeys: String, CodingKey {
        case id          = "id"
        case name        = "name"
        case valueName   = "value_name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        valueName = try container.decodeIfPresent(String.self, forKey: .valueName)
    }
}
