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
    let ingredientsText: String?
    let additivesTags: [String]?
    let ingredientsAnalysisTags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case nutriscoreGrade = "nutriscore_grade"
        case ingredientsText = "ingredients_text"
        case additivesTags = "additives_tags"
        case ingredientsAnalysisTags = "ingredients_analysis_tags"
    }
}

extension ProductDetail {

    var warningMessages: [String] {
        var warnings: [String] = []
    
        if let tags = ingredientsAnalysisTags, tags.contains("en:palm-oil") {
            warnings.append("Contains palm oil")
        }
        
        if let additives = additivesTags, !additives.isEmpty {
            warnings.append("Contains \(additives.count) additive(s)")
        }
        
        if let tags = ingredientsAnalysisTags, tags.contains("en:non-vegan") {
            warnings.append("Non-vegan")
        }
        
        return warnings
    }
    
}
