//
//  SearchViewModel.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 16/08/25.
//

import UIKit

public final class SearchViewModel {
    
    public enum SearchError: Error {
        case noData
        case invalidData(reason: String)
        case mockFileLoadError(reason: String)
        
        var detail: String {
            switch self {
            case .noData:
                return "Nenhum produto encontrado para o termo buscado."
            case .invalidData(let reason):
                return "Dados inválidos: \(reason)"
            case .mockFileLoadError:
                return "Erro ao carregar dados do arquivo JSON."
            }
        }
    }
    
    public func search(query: String, completion: @escaping(Result<SearchProductResult,SearchError>) -> Void) -> Void {
        
        // NOTE: Em uma aplicação comercial aqui seria chamada a classe de serviço para consumo de APIs.
        // Para simplificação deste teste, tratativas adicionais são desnecessárias.
        
        let productPrefix: String = "search-MLA"
        
        let content = FileServices.loadContent(from: "\(productPrefix)-\(query)")
        switch content {
        case .success(let data):
            do {
                let result = try JSONDecoder().decode(SearchProductResult.self, from: data)
                //
                completion(Result.success(result))
            } catch (let error) {
                completion(Result.failure(SearchError.invalidData(reason: error.localizedDescription)))
            }
            
        case .failure(let failure):
            completion(Result.failure(SearchError.mockFileLoadError(reason: failure.localizedDescription)))
        }
    }
    
    public func openSearchResult(for query: String, data: [ProductData], sender: UIViewController) -> Void {
        
        // NOTE: Este deslocamento entre telas, numa aplicação comercial, ficaria a cargo de um Coordinator/Router. Apenas para fins de teste, o próprio ViewModel executa esta função.
        
        let vm = ResultViewModel(query: query, products: data)
        let vc = ResultViewController(viewModel: vm)
        //
        sender.navigationController?.pushViewController(vc, animated: true)
    }
}
