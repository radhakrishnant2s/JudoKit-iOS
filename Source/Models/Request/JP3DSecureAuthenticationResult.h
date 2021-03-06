//
//  JP3DSecureAuthenticationResult.h
//  JudoKit_iOS
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

#import <Foundation/Foundation.h>

@interface JP3DSecureAuthenticationResult : NSObject

/**
 * A reference to the MD value returned from the 3D Secure ACS URL
 */
@property (nonatomic, strong, nonnull) NSString *md;

/**
 * A reference to the PaRes value returned from the 3D Secure ACS URL
 */
@property (nonatomic, strong, nonnull) NSString *paRes;

/**
 * Designated initializer based on the MD and RaRes values provided
 *
 * @param paRes - the PaRes value from the ACS URL
 * @param md - the MD value from the ACS URL
 *
 * @returns a configured JP3DSecureAuthenticationResult instance
 */
- (nonnull instancetype)initWithPaRes:(nonnull NSString *)paRes
                                andMd:(nonnull NSString *)md;

@end
