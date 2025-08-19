//
//  LoadingImageViewer.swift
//  PSMarketplace
//
//  Created by Erico G Teixeira on 18/08/25.
//

import UIKit

public class LoadingImageViewer: UIView {
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor  = UIColor.white
        return iv
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var aIndicator = UIActivityIndicatorView(style: .large)
        aIndicator.translatesAutoresizingMaskIntoConstraints = false
        aIndicator.hidesWhenStopped = true
        aIndicator.color = UIColor(named: "Foreground_Primary")
        aIndicator.stopAnimating()
        return aIndicator
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        //
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(imageView)
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 0.0),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 0.0)
        ])
    }
    
    func configure(with picture: ProductPicture) {
        
        if let img = picture.image {
            self.imageView.image = img
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
            self.imageView.image = nil
            //
            picture.loadContent {
                self.activityIndicator.stopAnimating()
                self.imageView.image = picture.image
            }
        }
    }
}
