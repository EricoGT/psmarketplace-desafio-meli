//
//  ProductContent.swift
//  PSMarketplace
//
//  Created by Erico G Teixeira on 18/08/25.
//

import UIKit

public class ProductPicture: Decodable {
    
    let secureURL: String
    //
    var image: UIImage? = nil
    
    private enum CodingKeys: String, CodingKey {
        case secureURL          = "secure_url"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //
        secureURL = try container.decode(String.self, forKey: .secureURL)
        //
        image = nil
    }
    
    func loadContent(completion: @escaping() -> Void) -> Void {
        ImageProvider.shared.image(fromURL: self.secureURL, usingCache: true) { [weak self] image in
            self?.image = image
            completion()
        }
    }
}
