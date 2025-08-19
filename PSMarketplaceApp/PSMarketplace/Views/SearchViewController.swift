//
//  SearchViewController.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 16/08/25.
//

import UIKit

class SearchViewController: BaseViewController {

    // MARK: - Properties
    
    // Data:
    
    private let viewModel: SearchViewModel
    
    // Layout
   
    private lazy var tipLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = UIColor.gray
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var resultLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.red
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var aIndicator = UIActivityIndicatorView(style: .large)
        aIndicator.translatesAutoresizingMaskIntoConstraints = false
        aIndicator.hidesWhenStopped = true
        return aIndicator
    }()
    
    private lazy var searchController: UISearchController = {
        let sController = UISearchController()
        sController.searchBar.tintColor = UIColor(named: "Foreground_Primary")
        return sController
    }()
    
    // MARK: - Life Cycle / Init
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureInitialLayout()
        
        self.navigationItem.searchController = self.searchController
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) -> Void {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
    }

    // MARK: - Other Overrides
    
    override func setupSubviews() -> Void {
        self.view.addSubview(self.tipLabel)
        self.view.addSubview(self.resultLabel)
        self.view.addSubview(self.activityIndicator)
    }
    
    override func setupConstraints() -> Void {
        
        NSLayoutConstraint.activate([
            self.tipLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0),
            self.tipLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.tipLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            //
            self.resultLabel.topAnchor.constraint(equalTo: self.tipLabel.bottomAnchor, constant: 50.0),
            self.resultLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.resultLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            //
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0)
        ])
    }
    
    override func setupDelegates() -> Void {
        self.searchController.searchBar.delegate = self
    }
    
    // MARK: Private Methods
    
    private func configureInitialLayout() -> Void {
        
        self.title = "Buscar"
        
        self.searchController.searchBar.placeholder = "Buscar no Mercado Livre"
        
        self.tipLabel.text = "\nConsiderações importantes:\n\nA busca deste app de demonstração está mockada em arquivos JSON. As palavras relevantes para resultados são: arroz, café, camisa, iphone, zapatillas.\n"
    }
    
    private func searchProducts(for text: String, originalText: String) -> Void {
        
        self.viewModel.search(query: text) { result in
            
            switch result {
            case .success(let data):
                if data.results.count > 0 {
                    self.viewModel.openSearchResult(for: originalText, data: data.results, sender: self)
                } else {
                    self.resultLabel.text = "\n\nNenhum item encontrado para sua busca...\n\n"
                }
                
            case .failure(let failure):
                self.resultLabel.text = "\n\n\(failure.detail)\n\n"
            }
            //
            self.activityIndicator.stopAnimating()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resultLabel.text = nil
        self.activityIndicator.stopAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            self.activityIndicator.startAnimating()
            
            MainExecutor.runAfter(seconds: 1.0) {
                
                let searchString: String = searchText.strippingDiacriticsForSearch()
                
                self.searchProducts(for: searchString, originalText: searchText)
            }
        }
    }
}
