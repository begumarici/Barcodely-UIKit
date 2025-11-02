//
//  APIService.swift
//  Barcodely
//
//  Created by Begüm Arıcı on 2.11.2025.
//

import Foundation

class APIService {
    private let baseURL = "https://world.openfoodfacts.org/api/v2/product/"
    private let urlSession: URLSession
    
    
    init() {
        urlSession = URLSession.shared
    }
    
    func fetchProduct(barcode: String, completion: @escaping (ProductResponse?) -> Void) {
        let urlString = baseURL + barcode + ".json"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ProductResponse.self, from: data)
                completion(response)
            } catch {
                completion(nil)
            }
            
            
            
        }.resume()
    }
}
