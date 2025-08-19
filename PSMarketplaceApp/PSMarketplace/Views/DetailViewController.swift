//
//  DetailViewController.swift
//  PSMarketplace
//
//  Created by Erico G Teixeira on 18/08/25.
//

import UIKit

class DetailViewController: BaseViewController {

    // MARK: - Properties
    
    // Data:
    
    private let viewModel: DetailViewModel
    
    private var productDetail: ProductDetail? = nil
    
    // Layout
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var aIndicator = UIActivityIndicatorView(style: .large)
        aIndicator.translatesAutoresizingMaskIntoConstraints = false
        aIndicator.hidesWhenStopped = true
        aIndicator.tintColor = UIColor(named: "Foreground_Primary")
        return aIndicator
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
        tv.separatorColor = UIColor.lightGray
        tv.separatorInset = .zero
        tv.allowsSelection = false
        //
        tv.register(ProductItemImagesCell.self, forCellReuseIdentifier: ProductItemImagesCell.identifier)
        tv.register(ProductItemDetailCell.self, forCellReuseIdentifier: ProductItemDetailCell.identifier)
        //
        return tv
    }()

    // MARK: - Life Cycle / Init
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(named: "Background_Secondary")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureInitialLayout()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) -> Void {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        
        MainExecutor.runAfter(owner: self, seconds: 0.5) {
            self.proccessDataForCurrentProduct()
        }
    }

    // MARK: - Other Overrides
    
    override func setupSubviews() -> Void {
        self.view.addSubview(activityIndicator)
        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() -> Void {
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0),
            
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func setupDelegates() -> Void {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // MARK: Private Methods
    
    private func proccessDataForCurrentProduct() -> Void {
        self.getCategoryData()
    }
    
    private func getCategoryData() -> Void {
        
        // NOTE: Neste exemplo o detalhe da categoria está sendo considerado obrigatório para o sucesso do processamento para justificar a leitura de mais arquivos JSON e mostrar a integração entre eles.
        
        self.viewModel.loadCategoryData(for: self.viewModel.product.id) { result in
            
            switch result {
            case .success(_):
                self.getContentData()
                
            case .failure(let failure):
                switch failure {
                
                case .noData:
                    self.showProccessError(message: "O arquivo mockk de teste não contém os dados solicitados.")
                    
                case .invalidData(reason: let reason):
                    self.showProccessError(message: "Falha na busca por detalhes da categoria:\n\n\(reason)")
                    
                case .mockFileLoadError(reason: _):
                    self.showProccessError(message: "Os dados solicitados não estão disponíveis no arquivo mock de teste.")
                }
            }
        }
    }
    
    private func getContentData() -> Void {
        self.viewModel.loadContentData(for: self.viewModel.product.id) { result in
            switch result {
            case .success(_):
                self.validateAvailableContent()
                
            case .failure(let failure):
                switch failure {
                
                case .noData:
                    self.showProccessError(message: "O arquivo mockk de teste não contém os dados solicitados.")
                    
                case .invalidData(reason: let reason):
                    self.showProccessError(message: "Falha na busca por conteúdos adicionais:\n\n\(reason)")
                    
                case .mockFileLoadError(reason: _):
                    self.showProccessError(message: "Os dados solicitados não estão disponíveis no arquivo mock de teste.")
                }
            }
        }
    }
    
    private func validateAvailableContent() -> Void {
        if let pd = self.viewModel.createProductDetail() {
            self.productDetail = pd
            self.showDetail()
        } else {
            showProccessError(message: "Não é possível exibir o detalhe do produto neste momento...")
        }
    }
    
    private func showDetail() -> Void {
        self.activityIndicator.stopAnimating()
        //
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction, .curveEaseOut], animations: {
            self.tableView.alpha = 1.0
            self.tableView.reloadData()
        }, completion: nil)
    }
    
    private func showProccessError(message: String) -> Void {
        self.activityIndicator.stopAnimating()
        //
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    private func configureInitialLayout() -> Void {
        self.title = self.viewModel.product.id
        //
        self.tableView.alpha = 0.0
        self.activityIndicator.startAnimating()
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pd = self.productDetail {
            return pd.infoItens.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            // Célula das imagens:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductItemImagesCell.identifier, for: indexPath) as? ProductItemImagesCell else {
                return UITableViewCell()
            }
            
            guard let content = self.productDetail?.content else {
                return UITableViewCell()
            }

            cell.configure(data: content)
            return cell
        } else {
            // Célula de dados:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductItemDetailCell.identifier, for: indexPath) as? ProductItemDetailCell else {
                return UITableViewCell()
            }
            
            guard let detail = self.productDetail else {
                return UITableViewCell()
            }
            
            let item = detail.infoItens[indexPath.row - 1]
            cell.configure(data: item)
            return cell
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 300 : UITableView.automaticDimension
    }
}
