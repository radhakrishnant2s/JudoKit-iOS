//
//  NSBundle+Additions.m
//  JudoKit-iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "JudoKit.h"
#import "NSBundle+Additions.h"

@implementation NSBundle (Additions)

+ (NSBundle *)frameworkBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleForClass:[JudoKit class]];
    });
    return bundle;
}

+ (NSBundle *)iconsBundle {
    static NSBundle *iconsBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *iconBundlePath = [NSBundle pathForResourceBundle:@"icons"];
        iconsBundle = [NSBundle bundleWithPath:iconBundlePath];
    });
    return iconsBundle;
}

+ (instancetype)stringsBundle {
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *podPath = [NSBundle.frameworkBundle pathForResource:@"JudoKit-iOS"
                                                               ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:podPath];
    });
    return bundle;
}

+ (instancetype)resourcesBundle {
    static NSBundle *iconsBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *iconBundlePath = [NSBundle pathForResourceBundle:@"resources"];
        iconsBundle = [NSBundle bundleWithPath:iconBundlePath];
    });
    return iconsBundle;
}

+ (NSString *)pathForResourceBundle:(NSString *)resourceBundle {
    for (NSBundle *bundle in [NSBundle allBundles]) {
        NSString *bundlePath = [bundle pathForResource:resourceBundle ofType:@"bundle"];
        if (bundlePath) {
            return bundlePath;
        }
    }

    for (NSBundle *bundle in [NSBundle allFrameworks]) {
        NSString *bundlePath = [bundle pathForResource:resourceBundle ofType:@"bundle"];
        if (bundlePath) {
            return bundlePath;
        }
    }
    return nil;
}
@end
