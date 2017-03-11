//
//  SYNetworkConfig.m
//  DPHMechart
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "SYRequestConfig.h"

@implementation SYRequestConfig
{
    NSString *_baseUrl;
    NSTimeInterval _timeOutInterval;
    NSUInteger _cacheLimitCount;
    NSDictionary *_serviceStorage;
}

+ (SYRequestConfig *)sharedConfig {
    static id sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}

- (void)configBaseUrl:(NSString *)base
      timeOutInterval:(NSTimeInterval)timeout
      cacheCountLimit:(NSUInteger)cacheCountLimit {
    _baseUrl = base ? [base copy] : nil;
    _timeOutInterval = timeout ? timeout : 60;
    _cacheLimitCount = cacheCountLimit ? cacheCountLimit : 1000;
}

- (void)configTimeOutInterval:(NSTimeInterval)timeout
              cacheCountLimit:(NSUInteger)cacheCountLimit
               serviceStorage:(NSArray *)serviceArray {
    _timeOutInterval = timeout ? timeout : 60;
    _cacheLimitCount = cacheCountLimit ? cacheCountLimit : 1000;
    NSDictionary *dictionary = [NSDictionary dictionary];
    [serviceArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        [dictionary setValue:obj forKey:obj];
    }];
    _serviceStorage = dictionary;
}

- (NSDictionary *)serviceStorage {
    return _serviceStorage;
}
    
- (NSTimeInterval)timeOutInterval {
    return _timeOutInterval;
}
    
- (NSUInteger)cacheCountLimit {
    return _cacheLimitCount;
}

@end
