//
//  Product.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 1.11.2025.
//

struct ProductResponse: Codable {
    let code: String
    let product: ProductDetail?
    let status: Int
}

struct ProductDetail: Codable {
    let productName: String?
    let brands: String?
    let nutriscoreGrade: String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case nutriscoreGrade = "nutriscore_grade"
    }
}
