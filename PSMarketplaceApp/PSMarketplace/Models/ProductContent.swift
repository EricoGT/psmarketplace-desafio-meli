//
//  ProductPictures.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

public struct ProductContent: Decodable {
    
    let pictures: [ProductPicture]
    
    private enum CodingKeys: String, CodingKey {
        case pictures          = "pictures"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //
        pictures = try container.decode([ProductPicture].self, forKey: .pictures)
    }
}
