//
//  ProductDetailViewController.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 2.11.2025.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var nutriscoreLabel: UILabel!
    
    var product: ProductDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayProduct()
    }
    
    private func displayProduct() {
        guard let product = product else {
            print("no product")
            return
        }
        
        productNameLabel.text = product.productName ?? "no name"
        brandNameLabel.text = product.brands ?? "no brand"
        nutriscoreLabel.text = product.nutriscoreGrade ?? "no grade"
        
        print("product: \(product.productName ?? "no name")")
        print("marka: \(product.brands ?? "no brand")")
        print("nutriscore: \(product.nutriscoreGrade ?? "no grade")")
    }
}
 
