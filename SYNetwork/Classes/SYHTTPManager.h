//
//  SYRequesrCenter.h
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

#import <Foundation/Foundation.h>

/*
 *由这个类统一发出请求
 */

// 为以后根据网络情况作不同的处理
typedef NS_ENUM(NSInteger, SYRequestReachabilityStatus) {
    SYRequestReachabilityStatusUnknow = 0,
    SYRequestReachabilityStatusNotReachable,
    SYRequestReachabilityStatusViaWWAN,
    SYRequestReachabilityStatusViaWiFi
};

@class SYRequest;
@class SYResponse;
typedef void(^SYCallBackSuccess)(SYResponse *response , NSError *error);
typedef void(^SYCallBackFail)(NSUInteger requestID ,NSError *error);
@interface SYHTTPManager : NSObject
+ (instancetype)sharedInstance;

- (NSInteger)startRequest:(SYRequest *)request
                  success:(SYCallBackSuccess)success
                     fail:(SYCallBackFail)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@property (nonatomic ,assign ,getter=isReachability) BOOL reachability;
@property (nonatomic, assign, readonly) SYRequestReachabilityStatus reachabilityStatus;

@end
