//
//  PCMarketplaceTests.swift
//  PCMarketplaceTests
//
//  Created by Erico G Teixeira on 16/08/25.
//

import Foundation
import Testing

@testable import PSMarketplace

struct PSMarketplaceTests {
    
    @Test(arguments: ["arroz", "cafe", "iphone", "camisa", "zapatillas", "abacaxi"]) func checkMockFile(name: String) {
        
        let result1 = loadFile(name: name)
        switch result1 {
        case .success(let data):
            #expect(data.count > 0)
        case .failure(let failure):
            switch failure {
            case .nonExistentFile:
                #expect(Bool(true))
            case .loadFileError(reason: _):
                #expect(Bool(false))
            }
        }
    }
    
    @Test(arguments: ["cafe", "café", "CAFE", "cafÉ"]) func validateSearchString(text: String) {
        #expect(text.strippingDiacriticsForSearch() == "cafe")
    }
    
    private func loadFile(name: String) -> Result<Data,FileServices.FileServicesError> {
        return FileServices.loadContent(from: "search-MLA-\(name)")
    }
}
