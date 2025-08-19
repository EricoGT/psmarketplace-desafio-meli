//
//  ProductSearchCell.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 17/08/25.
//

import UIKit

final class ProductSearchCell: UICollectionViewCell {
    
    static let identifier = "ProductSearchCell"
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var aIndicator = UIActivityIndicatorView(style: .large)
        aIndicator.translatesAutoresizingMaskIntoConstraints = false
        aIndicator.hidesWhenStopped = true
        aIndicator.color = UIColor(named: "Foreground_Primary")
        return aIndicator
    }()
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.white
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.textColor = .label
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .systemGreen
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let stockLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 12, weight: .regular)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.white
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            activityIndicator.centerXAnchor.constraint(equalTo: productImageView.centerXAnchor, constant: 0.0),
            activityIndicator.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor, constant: 0.0)
        ])
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func configure(with product: ProductData) {
        
        if let img = product.image {
            productImageView.image = img
        } else {
            self.activityIndicator.startAnimating()
            self.productImageView.image = nil
            //
            product.loadContent {
                self.activityIndicator.stopAnimating()
                self.productImageView.image = product.image
            }
        }
        nameLabel.text = product.title
        priceLabel.text = product.price.formatAsArgentinianPeso()
        stockLabel.text = "Disponível: \(product.availableQuantity)"
    }
}
