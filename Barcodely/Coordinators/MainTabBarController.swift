//
//  MainTabBarController.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 3.11.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViewControllers()
        setupNavigationCallbacks()
        setupTabBarAppereance()
    }
    
    // MARK: - Setup
    private func setupTabBarAppereance() {
        let appereance = UITabBarAppearance()
        appereance.configureWithOpaqueBackground()
        appereance.backgroundColor = .systemBackground
        
        appereance.stackedLayoutAppearance.selected.iconColor = .systemGreen
        appereance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        
        tabBar.standardAppearance = appereance
        tabBar.scrollEdgeAppearance = appereance
    }
    
    private func setupViewControllers() {
        let scannerVC = ScannerViewController()
        scannerVC.tabBarItem = UITabBarItem(
            title: "Scan",
            image: UIImage(systemName: "barcode.viewfinder"),
            tag: 0
        )
        
        let detailVC = ProductDetailViewController()
        detailVC.tabBarItem = UITabBarItem(
            title: "Detail",
            image: UIImage(systemName: "doc.text"),
            tag: 1
        )
        
        viewControllers = [scannerVC, detailVC]
    }
    
    private func setupNavigationCallbacks() {
        if let scannerVC = viewControllers?[0] as? ScannerViewController {
            scannerVC.onNavigateToDetail = { [weak self] product in
                self?.navigateToDetail(with: product)
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToDetail(with product: ProductDetail) {
        guard let detailVC = viewControllers?[1] as? ProductDetailViewController else {
            print("productdetailvc not found")
            return
        }
        
        detailVC.product = product
        selectedIndex = 1
    }
    
    
}
