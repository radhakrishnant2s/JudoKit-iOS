//
//  PaymentTests.swift
//  JudoTests
//
//  Copyright (c) 2016 Alternative Payments Ltd
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
@testable import JudoKitObjC

class TokenPaymentTests: JudoTestCase {
    
    func testJudoMakeValidTokenPayment() {
        // Given I have an SDK
        // When I provide the required fields
        let registerCard = judo.registerCardWithJudoId(myJudoID, amount: nil, reference: validReference)
        
        registerCard.card = validVisaTestCard
        
        let expectation = self.expectationWithDescription("token payment expectation")
        
        registerCard.sendWithCompletion({ (data, error) -> () in
            if let _ = error {
                XCTFail()
            } else {
                guard let uData = data else {
                    XCTFail("no data available")
                    return // BAIL
                }
                
                let consumerToken = uData.items?.first?.consumer.consumerToken
                let cardToken = uData.items?.first?.cardDetails?.cardToken
                
                let payToken = JPPaymentToken(consumerToken: consumerToken!, cardToken: cardToken!)
                
                // Then I should be able to make a token payment
                let payment = self.judo.paymentWithJudoId(self.myJudoID, amount: self.oneGBPAmount, reference: self.validReference)
                payment.paymentToken = payToken
                payment.sendWithCompletion({ (data, error) -> () in
                    if let error = error {
                        XCTFail("api call failed with error: \(error)")
                    }
                    expectation.fulfill()
                })
            }
        })
        XCTAssertNotNil(registerCard)
        XCTAssertEqual(registerCard.judoId, myJudoID)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoMakeTokenPaymentWithoutToken() {
        // Given I have an SDK
        let registerCard = judo.registerCardWithJudoId(myJudoID, amount: nil, reference: validReference)
        registerCard.card = validVisaTestCard
        
        let expectation = self.expectationWithDescription("token payment expectation")
        
        registerCard.sendWithCompletion({ (data, error) -> () in
            if let _ = error {
                XCTFail()
            } else {
                
                // When I do not provide a card token
                let payment = self.judo.paymentWithJudoId(self.myJudoID, amount: self.oneGBPAmount, reference: self.validReference)
                payment.sendWithCompletion({ (data, error) -> () in
                    XCTAssertEqual(error!.code, Int(JudoError.ErrorPaymentMethodMissing.rawValue))
                    expectation.fulfill()
                })
            }
        })
        XCTAssertNotNil(registerCard)
        XCTAssertEqual(registerCard.judoId, myJudoID)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoMakeTokenPaymentWithoutReference() {
        // Given I have an SDK
        let registerCard = judo.registerCardWithJudoId(myJudoID, amount: nil, reference: validReference)
        registerCard.card = validVisaTestCard
        
        let expectation = self.expectationWithDescription("token payment expectation")
        
        registerCard.sendWithCompletion({ (data, error) -> () in
            if let _ = error {
                XCTFail()
            } else {
                guard let uData = data else {
                    XCTFail("no data available")
                    return // BAIL
                }
                
                let consumerToken = uData.items?.first?.consumer.consumerToken
                let cardToken = uData.items?.first?.cardDetails?.cardToken
                
                let payToken = JPPaymentToken(consumerToken: consumerToken!, cardToken: cardToken!)
                
                // When I do not provide a consumer reference
                // Then I should receive an error
                let payment = self.judo.paymentWithJudoId(self.myJudoID, amount: self.oneGBPAmount, reference: self.invalidReference)
                payment.paymentToken = payToken
                payment.sendWithCompletion({ (response, error) -> () in
                    XCTAssertNil(response)
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error!.code, Int(JudoError.ErrorGeneral_Model_Error.rawValue))
                    
                    expectation.fulfill()
                })
            }
        })
        XCTAssertNotNil(registerCard)
        XCTAssertEqual(registerCard.judoId, myJudoID)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testJudoMakeTokenPaymentWithoutAmount() {
        // Given I have an SDK
        let registerCard = judo.registerCardWithJudoId(myJudoID, amount: nil, reference: validReference)
        registerCard.card = validVisaTestCard
        
        let expectation = self.expectationWithDescription("token payment expectation")
        
        registerCard.sendWithCompletion({ (data, error) -> () in
            if let _ = error {
                XCTFail()
            } else {
                guard let uData = data else {
                    XCTFail("no data available")
                    return // BAIL
                }
                
                let consumerToken = uData.items?.first?.consumer.consumerToken
                let cardToken = uData.items?.first?.cardDetails?.cardToken
                
                let payToken = JPPaymentToken(consumerToken: consumerToken!, cardToken: cardToken!)
                
                // When I do not provide an amount
                // Then I should receive an error
                let payment = self.judo.paymentWithJudoId(self.myJudoID, amount: self.invalidCurrencyAmount, reference: self.validReference)
                payment.paymentToken = payToken
                payment.sendWithCompletion({ (response, error) -> () in
                    XCTAssertNil(response)
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error!.code, Int(JudoError.ErrorGeneral_Model_Error.rawValue))
                    
                    expectation.fulfill()
                })
            }
        })
        // Then
        XCTAssertNotNil(registerCard)
        XCTAssertEqual(registerCard.judoId, myJudoID)
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}