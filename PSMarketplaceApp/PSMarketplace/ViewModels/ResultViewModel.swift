//
//  ResultViewModel.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 16/08/25.
//

import UIKit

public final class ResultViewModel {
    
    public let query: String
    public let products: [ProductData]
    
    init(query: String, products: [ProductData]) {
        self.query = query
        self.products = products
    }
    
    public func openDetail(for product: ProductData, sender: UIViewController) -> Void {
        
        // NOTE: Este deslocamento entre telas, numa aplicação comercial, ficaria a cargo de um Coordinator/Router. Apenas para fins de teste, o próprio ViewModel executa esta função.
        
        let vm = DetailViewModel(product: product)
        let vc = DetailViewController(viewModel: vm)
        //
        sender.navigationController?.pushViewController(vc, animated: true)
    }
}
