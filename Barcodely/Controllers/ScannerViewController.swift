//
//  ScannerViewController.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 31.10.2025.
//

import UIKit

class ScannerViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = ScanViewModel()
    
    var onNavigateToDetail: ((ProductDetail) -> Void)?
    
    // MARK: - UI Components
    private let previewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Point camera at barcode"
        label.textColor = .white
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private let scanButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Scan Barcode", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
       
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        setupActions()
        viewModel.setupCamera(on: previewView)
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanButton.isEnabled = true
        scanButton.setTitle("Scan Barcode", for: .normal)
        scanButton.backgroundColor = .systemGreen
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopScanning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.updatePreviewLayerFrame(previewView.bounds)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(previewView)
        view.addSubview(instructionLabel)
        view.addSubview(scanButton)
        view.addSubview(loadingIndicator)
        view.addSubview(loadingLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.widthAnchor.constraint(equalToConstant: 250),
            instructionLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.widthAnchor.constraint(equalToConstant: 200),
            scanButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 16),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - UI Components
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Searching product..."
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    // MARK: - Loading State
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            UIView.animate(withDuration: 0.3) {
                self.loadingLabel.alpha = 1
                self.instructionLabel.alpha = 0
            }
        } else {
            loadingIndicator.stopAnimating()
            UIView.animate(withDuration: 0.3) {
                self.loadingLabel.alpha = 0
                self.instructionLabel.alpha = 1
            }
        }
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onBarcodeScanned = { barcode in
            print("barcode has read: \(barcode)")
        }
        
        viewModel.onProductFetched = { [weak self] product in
            print("product found: \(product.productName ?? "")")
            
            DispatchQueue.main.async {
                self?.scanButton.backgroundColor = .systemGreen
                
                self?.onNavigateToDetail?(product)
            }
        }
        
        viewModel.onError = { [weak self] error in
            print("error: \(error)")
            DispatchQueue.main.async {
                self?.scanButton.isEnabled = true
                self?.scanButton.setTitle("Scan Again", for: .normal)
                self?.scanButton.backgroundColor = .systemGreen
                
                self?.showErrorAlert(message: error)
            }
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.updateLoadingState(isLoading)
            }
        }
    }
    
    // MARK: - Alert
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Product Not Found",
            message: "The scanned product is not available in the database. Please try another barcode.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func scanButtonTapped() {
        viewModel.startScanning()
        scanButton.isEnabled = false
        scanButton.setTitle("Scanning...", for: .normal)
        scanButton.backgroundColor = .systemGray
    }
    
}

