//
//  JPErrorAdditionsTests.swift
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

class JPErrorAdditionsTests: XCTestCase {
    
    /*
     * GIVEN: the JPError is initialized with the custom judoRequestFailedError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoRequestFailedError_SetCorrectLocalizedDescription() {
        let error = JPError.judoRequestFailedError()
        XCTAssertEqual(error.localizedDescription, "The request has failed or responded without data.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoJSONSerializationFailedWithError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoJSONSerializationFailedWithError_SetCorrectErrorCode() {
        let testError = NSError(domain: "test", code: 400, userInfo: nil)
        let error = JPError.judoJSONSerializationFailedWithError(testError)
        let judoErrorJSONSerializationFailed = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, judoErrorJSONSerializationFailed)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoUserDidCancelError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoUserDidCancelError_SetCorrectLocalizedDescription() {
        let error = JPError.judoUserDidCancelError()
        XCTAssertEqual(error.localizedFailureReason, "The user closed the transaction flow without completing the transaction.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoParameterError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoParameterError_SetCorrectLocalizedDescription() {
        let error = JPError.judoResponseParseError()
        let parameterError = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, parameterError)
        XCTAssertEqual(error.localizedDescription, "Unexpected response format returned.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInternetConnectionError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInternetConnectionError_SetCorrectLocalizedDescription() {
        let error = JPError.judoInternetConnectionError()
        XCTAssertEqual(error.localizedFailureReason, "The request could not be sent due to no internet connection.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoResponseParseError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoResponseParseError_SetCorrectLocalizedDescription() {
        let error = JPError.judoResponseParseError()
        XCTAssertEqual(error.localizedFailureReason, "The response did not contain some of the required parameters needed to complete the transaction.")
        XCTAssertEqual(error.localizedDescription, "Unexpected response format returned.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoRequestTimeoutError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoRequestTimeoutError_SetCorrectErrorCode() {
        let error = JPError.judoRequestTimeoutError()
        let timeoutError = Int(JudoError(rawValue: 1)!.rawValue)
        XCTAssertEqual(error.code, timeoutError)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInvalidCardNumberError initializer
     *
     * THEN:  it should set the correct error code
     */
    func test_WhenJudoInvalidCardNumberError_SetCorrectErrorCode() {
        let error = JPError.judoInvalidCardNumberError()
        let cardNumberError = Int(JudoError(rawValue: 0)!.rawValue)
        XCTAssertEqual(error.code, cardNumberError)
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoUnsupportedCardNetwork AMEX initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoUnsupportedCardNetwork_SetCorrectLocalizedDescription() {
        let error = JPError.judoUnsupportedCardNetwork(.AMEX)
        XCTAssertEqual(error.localizedDescription, "American Express is not supported")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judo3DSRequest initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudo3DSRequest_SetCorrectLocalizedDescription() {
        let error = JPError.judo3DSRequest(withPayload: ["test": "testData"])
        let errorUserInfo = error.userInfo["test"] as! String
        XCTAssertEqual(errorUserInfo, "testData")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoInvalidIDEALCurrencyError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInvalidIDEALCurrencyError_SetCorrectLocalizedDescription() {
        let error = JPError.judoInvalidIDEALCurrencyError()
        XCTAssertEqual(error.localizedDescription, "iDEAL transactions only support EUR as the currency.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoApplePayNotSupportedError initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoApplePayNotSupportedError_SetCorrectLocalizedDescription() {
        let error = JPError.judoApplePayNotSupportedError()
        XCTAssertEqual(error.localizedDescription, "Apple Pay is not supported on this device.")
    }
   
    /*
     * GIVEN: the JPError is initialized with the custom judoInvalidPBBACurrency initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoInvalidPBBACurrency_SetCorrectLocalizedDescription() {
        let error = JPError.judoInvalidPBBACurrencyError()
        XCTAssertEqual(error.localizedDescription, "PBBA transactions only support GBP as the currency.")
    }
    
    /*
     * GIVEN: the JPError is initialized with the custom judoPBBAURLSchemeMissing initializer
     *
     * THEN:  it should set the correct localizedDescription parameter
     */
    func test_WhenJudoPBBAURLSchemeMissing_SetCorrectLocalizedDescription() {
        let error = JPError.judoPBBAURLSchemeMissingError()
        XCTAssertEqual(error.localizedDescription, "PBBA transactions require the deeplink scheme to be set.")
    }
}
