//
//  BaseViewController.swift
//  PCMarketplace
//
//  Created by Erico G Teixeira on 16/08/25.
//

import UIKit

public class BaseViewController: UIViewController {
    
    override public func loadView() {
        super.loadView()
        //
        self.prepareInterface()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        self.configureDefaultNavigationLayout()
    }
    
    // MARK: - Public Methods
    
    public func setupSubviews() -> Void {
        fatalError("\(#function) method must have been overriden in subclass of BaseViewController.")
    }
    
    public func setupConstraints() -> Void {
        fatalError("\(#function) method must have been overriden in subclass of BaseViewController.")
    }
    
    public func setupDelegates() -> Void {
        fatalError("\(#function) method must have been overriden in subclass of BaseViewController.")
    }
    
    // MARK: - Private Methods
    
    private func prepareInterface() -> Void {
        self.setupSubviews()
        self.setupConstraints()
        self.setupDelegates()
        self.defaultSetup()
    }
    
    private func configureDefaultNavigationLayout() -> Void {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:" ", style:.plain, target:nil, action:nil)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let backColor: UIColor? = UIColor(named: "Background_Primary")
        let foreColor: UIColor? = UIColor(named: "Foreground_Primary")
        
        // NavigationBar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backColor
        appearance.shadowColor = UIColor.clear
        appearance.shadowImage = nil
        //
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        //
        self.navigationController?.navigationBar.tintColor = foreColor
        self.navigationController?.navigationBar.barTintColor = backColor
        self.navigationController?.navigationBar.backgroundColor = backColor
        
        // ToolBar
        let tappearance = UIToolbarAppearance()
        tappearance.configureWithOpaqueBackground()
        tappearance.backgroundColor = backColor
        tappearance.shadowColor = UIColor.clear
        tappearance.shadowImage = nil
        //
        self.navigationController?.toolbar.isTranslucent = false
        self.navigationController?.toolbar.standardAppearance = tappearance
        self.navigationController?.toolbar.scrollEdgeAppearance = tappearance
        self.navigationController?.toolbar.compactAppearance = tappearance
        self.navigationController?.toolbar.barTintColor = backColor
        self.navigationController?.toolbar.tintColor = foreColor
        
        // SearchBar
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "Foreground_Primary")!]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as [NSAttributedString.Key : Any] , for: .normal)
        
        self.navigationController?.navigationItem.searchController?.searchBar.tintColor = foreColor
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func defaultSetup() {
        self.view.backgroundColor = UIColor.white
    }
}
