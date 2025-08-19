//
//  Extensions.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import Foundation

// NOTE: O ideal é ter um arquivo de extension para cada tipo de dado...

extension String {
    
    func strippingDiacriticsForSearch() -> String {
        return self.folding(options: .diacriticInsensitive, locale: .current).lowercased()
    }
    
    func removingSymbols() -> String {
        return self.filter { $0.isLetter || $0.isNumber }
    }
}

extension Comparable {
    
    func clamp(low: Self, high: Self) -> Self {
        if (self > high) {
            return high
        } else if (self < low) {
            return low
        }
        return self
    }
}

extension Decimal {
    
    func formatAsArgentinianPeso() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_AR") // Argentina
        formatter.currencyCode = "ARS"
        
        return formatter.string(from: self as NSDecimalNumber) ?? "$\(self)"
    }
}
