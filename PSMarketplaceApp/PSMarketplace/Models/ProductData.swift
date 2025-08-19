//
//  ProductData.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

public class ProductData: Decodable {
    let id: String
    let title: String
    let thumbnail: String
    let categoryId: String
    let price: Decimal
    let availableQuantity: Int
    let attributes: [ProductAttributes]
    //
    var image: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case id          = "id"
        case title        = "title"
        case thumbnail   = "thumbnail"
        case categoryId   = "category_id"
        case price   = "price"
        case availableQuantity   = "available_quantity"
        case attributes   = "attributes"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        categoryId = try container.decode(String.self, forKey: .categoryId)
        price = try container.decode(Decimal.self, forKey: .price)
        availableQuantity = try container.decode(Int.self, forKey: .availableQuantity)
        attributes = try container.decode([ProductAttributes].self, forKey: .attributes)
        //
        image = nil
    }
    
    func loadContent(completion: @escaping() -> Void) -> Void {
        ImageProvider.shared.image(fromURL: self.thumbnail, usingCache: true) { [weak self] image in
            self?.image = image
            completion()
        }
    }
}
