//
//  ProductDetailViewController.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 2.11.2025.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    // MARK: - Properties
    var product: ProductDetail?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let brandNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let ingredientsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ingredients"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let ingredientsTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 16)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .systemGray6
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return tv
    }()
    
    private let warningsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Warnings"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let warningsTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 16)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .systemGray6
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayProduct()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(productNameLabel)
        contentView.addSubview(brandNameLabel)
        contentView.addSubview(ingredientsHeaderLabel)
        contentView.addSubview(ingredientsTextView)
        contentView.addSubview(warningsHeaderLabel)
        contentView.addSubview(warningsTextView)
        
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            brandNameLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            brandNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            brandNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            ingredientsHeaderLabel.topAnchor.constraint(equalTo: brandNameLabel.bottomAnchor, constant: 32),
            ingredientsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            ingredientsTextView.topAnchor.constraint(equalTo: ingredientsHeaderLabel.bottomAnchor, constant: 12),
            ingredientsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ingredientsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            ingredientsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            warningsHeaderLabel.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: 32),
            warningsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            warningsTextView.topAnchor.constraint(equalTo: warningsHeaderLabel.bottomAnchor, constant: 12),
            warningsTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            warningsTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            warningsTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            warningsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    // MARK: - Private Methods
    private func displayProduct() {
        guard let product = product else {
            print("no product")
            return
        }
        
        productNameLabel.text = product.productName ?? "no name"
        brandNameLabel.text = product.brands ?? "no brand"
        
        ingredientsTextView.text = product.ingredientsText ?? "no ingredients available"
        ingredientsTextView.isEditable = false
        
        let warnings = product.warningMessages
        if warnings.isEmpty {
            warningsTextView.text = "no major warnings detected"
            warningsTextView.textColor = .systemGreen
        } else {
            warningsTextView.text = warnings.joined(separator: ",")
            warningsTextView.textColor = .systemRed
        }
        
        print("product: \(product.productName ?? "no name")")
        print("marka: \(product.brands ?? "no brand")")
        print("ingredients: \(product.ingredientsText ?? "no inggredients available")")
        print("warnings: \(product.warningMessages.joined(separator: ","))")
    }
}
