//
//  JPSDKInfoTest.swift
//  JudoKit_iOSTests
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

class JPSDKInfoTest: XCTestCase {
    
    /*
     * GIVEN: Creating JPSDKInfo designated init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPSDKInfo object
     */
    func test_InitWithVersion_WhenCreatingObject_ShouldReturnRightObject() {
        let infoSUT = JPSDKInfo(version: "version", name: "name")
        XCTAssertEqual(infoSUT.version, "version")
        XCTAssertEqual(infoSUT.name, "name")
    }
    
    /*
     * GIVEN: Creating JPSDKInfo class init
     *
     * WHEN: all fields are valid
     *
     * THEN: should create correct fields in JPSDKInfo object
     */
    func test_InfoWithVersion_WhenCreatingObject_ShouldReturnRightObject() {
        let infoSUT = JPSDKInfo.init(version: "version", name: "name")
        XCTAssertEqual(infoSUT.version, "version")
        XCTAssertEqual(infoSUT.name, "name")
    }
}
