//
//  JPContactInformation.h
//  JudoKit_iOS
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

#import <Foundation/Foundation.h>

@class JPPostalAddress;

/**
 * An object containing the Billing / Shipping information of the payment.
 * It is generated by JPApplePayService from a PKPayment object returned from
 * Apple Pay's delegate method.
 */
@interface JPContactInformation : NSObject

/**
 * The billing / shipping email address if specified in the JPApplePayConfiguration object;
 */
@property (nonatomic, strong, nullable) NSString *emailAddress;

/**
 * The name of the person if specified in the JPApplePayConfiguration object;
 */
@property (nonatomic, strong, nullable) NSPersonNameComponents *name;

/**
 * The billing / shipping phone number if specified in the JPApplePayConfiguration object;
 */
@property (nonatomic, strong, nullable) NSString *phoneNumber;

/**
 * The billing / shipping postal address if specified in the JPApplePayConfiguration object;
 */
@property (nonatomic, strong, nullable) JPPostalAddress *postalAddress;

/**
 * Designated initializer
 *
 * @param emailAddress - the email address returned from a PKContact object
 * @param name - the name components returned from a PKContact object
 * @param phoneNumber - the phone number returned from a PKContact object
 * @param postalAddress - a JPPostalAddress object containing location information
 */
- (nonnull instancetype)initWithEmailAddress:(nullable NSString *)emailAddress
                                        name:(nullable NSPersonNameComponents *)name
                                 phoneNumber:(nullable NSString *)phoneNumber
                               postalAddress:(nullable JPPostalAddress *)postalAddress;

/**
 * Helper method that generates a human-readable string from all the initialized parameters.
 */
- (nonnull NSString *)toString;

@end
