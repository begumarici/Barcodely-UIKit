//
//  ScanViewModel.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 31.10.2025.
//

import Foundation
import UIKit

class ScanViewModel {
    
    // MARK: - Properties
    let barcodeService = BarcodeService()
    let apiService = APIService()
    
    private(set) var isScanning: Bool = false
    private(set) var isLoading: Bool = false
    private(set) var product: ProductDetail?
    private(set) var errorMessage: String?
    
    var onBarcodeScanned: ((String) -> Void)?
    var onProductFetched: ((ProductDetail) ->Void)?
    var onError: ((String) -> Void )?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    init() {
        setupBarcodeService()
    }
    
    // MARK: - Setup
    private func setupBarcodeService() {
        barcodeService.onBarcodeDetected = { [weak self] barcode in
            self?.didScanBarcode(barcode)}
    }
    
    // MARK: - Public Methods
    func setupCamera(on view: UIView){
        barcodeService.setup(on: view)
    }
    
    func startScanning() {
        isScanning = true
        barcodeService.startScanning()
    }
    
    func stopScanning() {
        isScanning = false
        barcodeService.stopScanning()
    }
    
    func updatePreviewLayerFrame(_ frame: CGRect) {
        barcodeService.updatePreviewLayerFrame(frame)
    }

    // MARK: - Private Methods
    private func didScanBarcode(_ barcode: String) {
        
        stopScanning()
        
        onBarcodeScanned?(barcode)
        
        isLoading = true
        onLoadingStateChanged?(true)
        
        apiService.fetchProduct(barcode: barcode) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.onLoadingStateChanged?(false)
                
                if let product = response?.product {
                    self.product = product
                    self.onProductFetched?(product)
                } else {
                    self.errorMessage = "no product found"
                    self.onError?("no product faound")
                }
            }
        }
        
    }
}
