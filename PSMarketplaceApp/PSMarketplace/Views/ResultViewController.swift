//
//  ResultViewController.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

class ResultViewController: BaseViewController {

    // MARK: - Properties
    
    // Data:
    
    private let viewModel: ResultViewModel
    
    // Layout
   
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        let size = (UIScreen.main.bounds.width / 2) - 16
        layout.itemSize = CGSize(width: size, height: size * 1.4)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.register(ProductSearchCell.self, forCellWithReuseIdentifier: ProductSearchCell.identifier)
        cv.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        return cv
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
    
    // MARK: - Life Cycle / Init
    
    init(viewModel: ResultViewModel) {
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
    }

    // MARK: - Other Overrides
    
    override func setupSubviews() -> Void {
        self.view.addSubview(collectionView)
    }
    
    override func setupConstraints() -> Void {
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            self.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func setupDelegates() -> Void {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: Private Methods
    
    private func configureInitialLayout() -> Void {
        
        self.title = self.viewModel.query
        
        self.collectionView.reloadData()
    }
    
    private func showDetail(for product: ProductData) -> Void {
        
        self.viewModel.openDetail(for: product, sender: self)
    }
}

extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSearchCell.identifier, for: indexPath) as? ProductSearchCell else {
            return UICollectionViewCell()
        }
        
        let product = self.viewModel.products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.isUserInteractionEnabled = false
        //
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.alpha = 0.0
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowAnimatedContent, .curveEaseOut]) {
            cell?.contentView.alpha = 1.0
        } completion: { _ in
            let product = self.viewModel.products[indexPath.item]
            self.showDetail(for: product)
            //
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}
