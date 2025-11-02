//
//  ScannerViewController.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 31.10.2025.
//

import UIKit

class ScannerViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    
    private let viewModel = ScanViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setupCamera(on: previewView)
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanButton.isEnabled = true
        scanButton.setTitle("Scan Barcode", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopScanning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.updatePreviewLayerFrame(previewView.bounds)
    }
    
    private func setupBindings() {
        viewModel.onBarcodeScanned = { [weak self] barcode in
            print("barcode has read: \(barcode)")
        }
        
        viewModel.onProductFetched = { [weak self] product in
            print("product found: \(product.productName ?? "")")
            
            guard let tabBarController = self?.tabBarController else {
                print("tabbarcontroller not found")
                return
            }
            
            if let detailVC = tabBarController.viewControllers?[1] as? ProductDetailViewController {
                detailVC.product = product
                tabBarController.selectedIndex = 1
            }
        }
        
        viewModel.onError = { [weak self] error in
            print("error: \(error)")
            self?.scanButton.isEnabled = true
            self?.scanButton.setTitle("Scan Again", for: .normal)
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            print("loading: \(isLoading)")
        }
        
        
    }
    
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        viewModel.startScanning()
        scanButton.isEnabled = false
        scanButton.setTitle("Scanning...", for: .normal)
    }
    
}

