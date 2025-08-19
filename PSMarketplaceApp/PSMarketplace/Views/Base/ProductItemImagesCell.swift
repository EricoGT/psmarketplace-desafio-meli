//
//  ProductItemImagesCell.swift
//  PSMarketplace
//
//  Created by Erico G Teixeira on 18/08/25.
//

import UIKit

public class ProductItemImagesCell: UITableViewCell {
    
    static let identifier = "ProductItemImagesCell"
    //LoadingImageViewer
    
    private lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isPagingEnabled = true
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        return pc
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
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
            scrollView.heightAnchor.constraint(equalToConstant: 270.0),
            
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0.0),
            pageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
            pageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0)
        ])
    }
    
    public func configure(data: ProductContent) -> Void {
        
        self.pageControl.numberOfPages = data.pictures.count
        self.pageControl.currentPage = 0
        
        let width: CGFloat = UIScreen.main.bounds.size.width
        
        self.scrollView.subviews.forEach { $0.removeFromSuperview() }
        self.scrollView.contentSize = CGSizeMake(CGFloat(data.pictures.count) * width, 270.0)
        
        for i in 0 ..< data.pictures.count {
            let pic = data.pictures[i]
            
            let liv = LoadingImageViewer(frame: CGRectMake(CGFloat(i) * width, 10.0, width, 270.0))
            liv.translatesAutoresizingMaskIntoConstraints = true
            self.scrollView.addSubview(liv)
            liv.configure(with: pic)
        }
    }
}

extension ProductItemImagesCell: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.pageControl.currentPage = page
    }
}
