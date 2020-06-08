//
//  JPPBBAServiceTest.swift
//  JudoKit-iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest
@testable import JudoKit_iOS

class JPPBBAServiceTest: XCTestCase {
    let transactionService = JPTransactionService(token: "TOKEN", andSecret: "SECRET")
    let configuration = JPConfiguration(judoID: "judoId",
                                        amount: JPAmount("0.01", currency: "GBR"),
                                        reference: JPReference(consumerReference: "consumerReference"))
    var sut: JPPBBAService! = nil

    
    override func setUp() {
        sut = JPPBBAService(configuration: configuration, transactionService: transactionService)
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    /*
    * GIVEN: JPPBBAServiceTest start pbba flow
    *
    * WHEN: siteId is not presenting in configuration
    *
    * THEN: should return judoSiteIDMissingError error,
    */
    func testSiteIdEmpty() {
        configuration.siteId = nil
        sut.openPBBAMerchantApp { (res, error) in
            XCTAssertEqual(error, JPError.judoSiteIDMissingError())
        }
    }
    
    /*
    * GIVEN: JPPBBAServiceTest start pbba flow
    *
    * WHEN: siteId is presenting in configuration
    *
    * THEN: should return default error,
    */
    func testSiteIdNotEmpty() {
        configuration.siteId = "siteId"
        sut.openPBBAMerchantApp { (res, error) in
            XCTAssertNotEqual(error, JPError.judoSiteIDMissingError())
        }
    }
    
    /*
     * GIVEN: JPPBBAServiceTest start polling
     *
     * WHEN: response is unsuccess
     *
     * THEN: should return non nill error
     */
    func test_PollingPBBAMerchantApp_WhenRecieveDepplink_ShouldBeNotNill() {
        sut.pollingOrderStatus { (res, error) in
            XCTAssertNotNil(error)
        }
    }
}
