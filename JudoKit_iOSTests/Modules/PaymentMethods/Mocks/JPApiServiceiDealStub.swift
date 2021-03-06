//
//  JPTransactionServiceiDealStub.swift
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

class JPApiServiceiDealStub: JPApiService {
    override init() {
        
        let basicAuth: JPAuthorization = JPBasicAuthorization(token: "TOKEN", andSecret: "SECRET")
        super.init(authorization: basicAuth, isSandboxed: true)
        saveStubs()
    }
    
    func saveStubs() {
        stub(condition: isPath("/order/bank/sale")) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("SuccessResponse.json", type(of: self))!, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/order/bank/statusrequest")) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("PendingResponse.json", type(of: self))!, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/order/bank/statusrequest/123456")) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("SuccessResponse.json", type(of: self))!, statusCode: 200, headers: nil)
        }
    }
}
