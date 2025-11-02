//
//  BarcodelyTests.swift
//  BarcodelyTests
//
//  Created by Begüm Arıcı on 2.11.2025.
//

import XCTest
@testable import Barcodely

final class BarcodelyTests: XCTestCase {
    
    func testFetchProduct() {
        let apiService = APIService()
        let expectation = expectation(description: "api call should complete")
        
        apiService.fetchProduct(barcode: "8696368011493") { response in
            XCTAssertNotNil(response, "response should not be nil")
            XCTAssertNotNil(response?.product, "product should exist")
            XCTAssertEqual(response?.product?.productName, "Activia Pineapple")
        
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
}
