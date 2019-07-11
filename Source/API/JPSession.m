//
//  JPSession.m
//  JudoKitObjC
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

#import "JPSession.h"
#import "JPPagination.h"
#import "JPResponse.h"
#import "JPTransactionData.h"
#import "NSError+Judo.h"
#import "JudoKit.h"
#import <TrustKit/TrustKit.h>

@interface JPSession () <NSURLSessionDelegate>

@property (nonatomic, strong, readwrite) NSString *endpoint;
@property (nonatomic, strong, readwrite) NSString *authorizationHeader;
@property (nonatomic, strong, readwrite) TrustKit *trustKit;

@end

@implementation JPSession

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *trustKitConfig =
        @{
          kTSKPinnedDomains : @{
                  @"judopay-sandbox.com" : @{
                          kTSKPublicKeyHashes : @[
                                  @"mpCgFwbYmjH0jpQ3EruXVo+/S73NOAtPeqtGJE8OdZ0=",
                                  @"SRjoMmxuXogV8jKdDUKPgRrk9YihOLsrx7ila3iDns4="
                                  ],
                          kTSKIncludeSubdomains : @YES
                          },
                  @"gw1.judopay.com" : @{
                          kTSKPublicKeyHashes : @[
                                  @"SuY75QgkSNBlMtHNPeW9AayE7KNDAypMBHlJH9GEhXs=",
                                  @"c4zbAoMygSbepJKqU3322FvFv5unm+TWZROW3FHU1o8=",
                                  ],
                          kTSKIncludeSubdomains : @YES
                          }
                  }};

        self.trustKit = [[TrustKit alloc] initWithConfiguration:trustKitConfig];
    }
    return self;
}

#pragma mark - REST API

- (void)apiCall:(NSString *)HTTPMethod path:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    NSMutableURLRequest *request = [self judoRequest:[NSString stringWithFormat:@"%@%@", self.endpoint, path]];
    
    request.HTTPMethod = HTTPMethod;
    
    if (parameters) {
        NSError *error = nil;
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return; // BAIL
        }
    }
    
    NSURLSessionDataTask *task = [self task:request completion:completion];
    
    [task resume];
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    [self apiCall:@"POST" path:path parameters:parameters completion:completion];
}

- (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    [self apiCall:@"PUT" path:path parameters:parameters completion:completion];
}

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    [self apiCall:@"GET" path:path parameters:parameters completion:completion];
}

- (NSMutableURLRequest *)judoRequest:(NSString *)url {
    // create request and configure headers
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"5.0.0" forHTTPHeaderField:@"API-Version"];
    
    
    // Adds the version and lang of the SDK to the header
    [request addValue:[self getUserAgent] forHTTPHeaderField:@"User-Agent"];

    NSString *uiClientModeString = @"Judo-SDK";
    
    if (self.uiClientMode) {
        uiClientModeString = @"Custom-UI";
    }
    
    [request addValue:uiClientModeString forHTTPHeaderField:@"UI-Client-Mode"];
    
    // Check if token and secret have been set
    NSAssert(self.authorizationHeader, @"token and secret not set");
    
    // Set auth header
    [request addValue:self.authorizationHeader forHTTPHeaderField:@"Authorization"];

    return request;
}

- (NSString *)getUserAgent {
    
    UIDevice *device = [UIDevice currentDevice];
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSMutableArray<NSString *> *userAgentParts = [NSMutableArray new];
    
    //Base user agent
    [userAgentParts addObject:[NSString stringWithFormat:@"iOS-ObjC/%@", JudoKitVersion]];
    
    //Model
    [userAgentParts addObject:device.model];
    
    //Operating system
    [userAgentParts addObject:[NSString stringWithFormat:@"%@/%@", device.systemName, device.systemVersion]];
    
    NSString *appName = [mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *appVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    if (appName && appVersion) {
        //App Name and version
        NSString *appNameMinusSpaces = [appName stringByReplacingOccurrencesOfString:@" " withString:@""];
        [userAgentParts addObject:[NSString stringWithFormat:@"%@/%@", appNameMinusSpaces, appVersion]];
    }
    
    NSString *platformName = [mainBundle objectForInfoDictionaryKey:@"DTPlatformName"];
    
    if (platformName) {
        //Platform running on (simulator or device)
        [userAgentParts addObject:platformName];
    }
    
    return [userAgentParts componentsJoinedByString:@" "];
}

- (NSURLSessionDataTask *)task:(NSURLRequest *)request completion:(JudoCompletionBlock)completion {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    return [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // check if an error occurred
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, error);
                }
            });
            return; // BAIL
        }

        // check if response data is available
        if (!data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, [NSError judoRequestFailedError]);
                }
            });
            return; // BAIL
        }
        
        // serialize json
        __block NSError *jsonError = nil;
        
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

        if (jsonError || !responseJSON) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    if (!jsonError) {
                        jsonError = [NSError judoJSONSerializationFailedWithError:jsonError];
                    }
                    completion(nil, jsonError);
                }
            });
            return; // BAIL
        }
        
        // check if API Error was returned
        if (responseJSON[@"code"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, [NSError judoErrorFromDictionary:responseJSON]);
                }
            });
            return; // BAIL
        }
        
        // check if 3DS was requested
        if (responseJSON[@"acsUrl"] && responseJSON[@"paReq"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, [NSError judo3DSRequestWithPayload:responseJSON]);
                }
            });
            return; // BAIL
        }
        
        JPPagination *pagination = nil;
        
        if (responseJSON[@"offset"] && responseJSON[@"pageSize"] && responseJSON[@"sort"]) {
            pagination = [JPPagination paginationWithOffset:responseJSON[@"offset"]
                                                   pageSize:responseJSON[@"pageSize"]
                                                       sort:responseJSON[@"sort"]];
        }
        
        JPResponse *result = [[JPResponse alloc] initWithPagination:pagination];
        
        if (responseJSON[@"results"]) {
            [result appendItems:responseJSON[@"results"]];
        } else {
            [result appendItem:responseJSON];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                if (result.items.count == 1 && result.items.firstObject.result != TransactionResultSuccess) {
                    completion(nil, [NSError judoErrorFromTransactionData:result.items.firstObject]);
                } else {
                    completion(result, nil);
                }
            }
        });
        
    }];
}

#pragma mark - URLSession SSL pinning

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {

    TSKPinningValidator *pinningValidator = [self.trustKit pinningValidator];
    // Pass the authentication challenge to the validator; if the validation fails, the connection will be blocked
    if (![pinningValidator handleChallenge:challenge completionHandler:completionHandler]) {
        // TrustKit did not handle this challenge: perhaps it was not for server trust
        // or the domain was not pinned. Fall back to the default behavior
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

#pragma mark - getters and setters

- (NSString *)endpoint {
    if (self.sandboxed) {
        return @"https://gw1.judopay-sandbox.com/";
    } else {
        return @"https://gw1.judopay.com/";
    }
}

@end
