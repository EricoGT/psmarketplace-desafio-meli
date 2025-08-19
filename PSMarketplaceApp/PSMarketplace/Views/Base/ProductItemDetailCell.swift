//
//  ProductItemDetailCell.swift
//  PSMarketplace
//
//  Created by Erico G Teixeira on 18/08/25.
//

import UIKit

public class ProductItemDetailCell: UITableViewCell {
    
    static let identifier = "ProductItemDetailCell"
    
    //LoadingImageViewer
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = UIColor.black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.white
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            
            self.titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5.0),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            self.subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0)
        ])
    }
    
    public func configure(data: ProductDetailInfoItem) -> Void {
        self.titleLabel.text = data.name
        self.subtitleLabel.text = data.value
        //
        self.setNeedsLayout()
    }
}
