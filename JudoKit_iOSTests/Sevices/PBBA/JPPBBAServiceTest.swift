//
//  JPPBBAServiceTest.swift
//  JudoKit_iOSTests
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
    let configuration = JPConfiguration(judoID: "judoId",
                                        amount: JPAmount("0.01", currency: "GBP"),
                                        reference: JPReference(consumerReference: "consumerReference"))
    var sut: JPPBBAService! = nil
    
    override func setUp() {
        super.setUp()
        HTTPStubs.setEnabled(true)
        let ppbaConfig = JPPBBAConfiguration(deeplinkScheme: "judo",
                                             andDeeplinkURL: URL(string: "url?orderId=3333"))
        configuration.pbbaConfiguration = ppbaConfig
        
        sut = JPPBBAService(configuration: configuration, apiService: JPApiServicePBBAStub())
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    /*
     * GIVEN: JPPBBAServiceTest start polling
     *
     * WHEN: response is Success
     *
     * THEN: should return non nil response and equal with Success status
     */
    func test_PollingPBBAMerchantApp_WhenReceiveDeeplink_ShouldBeNotNil() {
        let expectation = self.expectation(description: "get response from pbba polling")
        
        let completion: JPCompletionBlock = { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertEqual(response?.orderDetails?.orderStatus, "Success")
            expectation.fulfill()
        }
        sut.pollingOrderStatus(completion)
        waitForExpectations(timeout: 6, handler: nil)
    }
    
    /*
    * GIVEN: JPPBBAServiceTest open PBBA Merchant App
    *
    * WHEN: response is wrong json
    *
    * THEN: should return error with code errorResponseParseError
    */
    func test_OpenPBBAMerchantApp_WhenReceiveWrongJson_ShouldReturnRightError() {
        stub(condition: isPath("/order/bank/sale")) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("OrderDetails.json", type(of: self))!, statusCode: 200, headers: nil)
        }
        let expectation = self.expectation(description: "await save transaction response")
        
        sut.openPBBAMerchantApp { (res, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, Int(JudoError.errorResponseParseError.rawValue))
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    /*
    * GIVEN: JPPBBAServiceTest open PBBA Merchant App
    *
    * WHEN: response is without pbbaBrn and secureToken
    *
    * THEN: should return error with code errorResponseParseError
    */
    func test_OpenPBBAMerchantApp_WhenDidntReceiveSecureToken_ShouldReturnRightError() {
        stub(condition: isPath("/order/bank/sale")) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("UnSuccessResponsePBBA.json", type(of: self))!, statusCode: 200, headers: nil)
        }
        
        let expectation = self.expectation(description: "await save transaction response")
        sut.openPBBAMerchantApp { (res, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.code, Int(JudoError.errorResponseParseError.rawValue))
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}
