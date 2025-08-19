//
//  ProductDetail.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

public struct ProductDetailInfoItem {
    let name: String
    let value: String
}

public struct ProductDetail {
    
    let product: ProductData
    let category: ProductCategoryData
    let content: ProductContent
    //
    var infoItens: [ProductDetailInfoItem] = []
    
    init(product: ProductData, category: ProductCategoryData, content: ProductContent) {
        self.product = product
        self.category = category
        self.content = content
        //
        self.proccessInfoItems()
    }
    
    public mutating func proccessInfoItems() -> Void {
        
        // Nome
        self.infoItens.append(ProductDetailInfoItem(name: "Produto", value: self.product.title))
        
        // Preço
        let price = self.product.price.formatAsArgentinianPeso()
        self.infoItens.append(ProductDetailInfoItem(name: "Preço", value: price))
        
        // Categoria
        self.infoItens.append(ProductDetailInfoItem(name: "Categoria", value: self.category.name))
        
        // Quantidade Disponível
        self.infoItens.append(ProductDetailInfoItem(name: "Quantidade disponível", value: "\(self.product.availableQuantity)"))
        
        // Marca
        if let marca = self.product.attributes.filter({ $0.id ==  "BRAND" }).first, let vName = marca.valueName {
            self.infoItens.append(ProductDetailInfoItem(name: "Marca", value: vName))
        }
        
        // Modelo
        if let modelo = self.product.attributes.filter({ $0.id ==  "MODEL" }).first, let vName = modelo.valueName {
            self.infoItens.append(ProductDetailInfoItem(name: "Modelo", value: vName))
        }
    }
}

