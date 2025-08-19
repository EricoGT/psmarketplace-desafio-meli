//
//  DetailViewModel.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 16/08/25.
//

import UIKit

public final class DetailViewModel {
    
    public enum LoadDataError: Error {
        case noData
        case invalidData(reason: String)
        case mockFileLoadError(reason: String)
        
        var detail: String {
            switch self {
            case .noData:
                return "Nenhum dado encontrado para o recurso solicitado."
            case .invalidData(let reason):
                return "Dados inválidos: \(reason)"
            case .mockFileLoadError:
                return "Erro ao carregar dados do arquivo JSON."
            }
        }
    }
    
    public let product: ProductData
    
    private var categoryData: ProductCategoryData? = nil
    private var contentData: ProductContent? = nil
    
    init(product: ProductData) {
        self.product = product
    }
    
    public func createProductDetail() -> ProductDetail? {
        guard let category = self.categoryData else {
            return nil
        }
        //
        guard let content = self.contentData else {
            return nil
        }
        //
        return ProductDetail(product: self.product, category: category, content: content)
    }
    
    public func loadCategoryData(for productId: String, completion: @escaping(Result<ProductCategoryData,LoadDataError>) -> Void) -> Void {
        
        // NOTE: Em uma aplicação comercial aqui seria chamada a classe de serviço para consumo de APIs.
        // Para simplificação deste teste, tratativas adicionais são desnecessárias.
        
        let fileName: String = "item-\(productId)-category"
        
        let content = FileServices.loadContent(from: fileName)
        switch content {
        case .success(let data):
            do {
                let result = try JSONDecoder().decode(ProductCategoryData.self, from: data)
                //
                self.categoryData = result
                completion(Result.success(result))
            } catch (let error) {
                completion(Result.failure(LoadDataError.invalidData(reason: error.localizedDescription)))
            }
            
        case .failure(let failure):
            completion(Result.failure(LoadDataError.mockFileLoadError(reason: failure.localizedDescription)))
        }
    }
    
    public func loadContentData(for productId: String, completion: @escaping(Result<ProductContent,LoadDataError>) -> Void) -> Void {
        
        // NOTE: Em uma aplicação comercial aqui seria chamada a classe de serviço para consumo de APIs.
        // Para simplificação deste teste, tratativas adicionais são desnecessárias.
        
        let fileName: String = "item-\(productId)"
        
        let content = FileServices.loadContent(from: fileName)
        switch content {
        case .success(let data):
            do {
                let result = try JSONDecoder().decode(ProductContent.self, from: data)
                //
                self.contentData = result
                completion(Result.success(result))
            } catch (let error) {
                completion(Result.failure(LoadDataError.invalidData(reason: error.localizedDescription)))
            }
            
        case .failure(let failure):
            completion(Result.failure(LoadDataError.mockFileLoadError(reason: failure.localizedDescription)))
        }
    }
}


