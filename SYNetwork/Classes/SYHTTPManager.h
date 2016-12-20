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

/// ALL kinds of requests are start from this kind of class,
/// this class is use to interactive with AFNetwork
/// this class is NOT OPEN to the busness layer.

/// because we ususlly need to have a different behaviors according to the different network environment
/// so this kind of ENUM is used
typedef NS_ENUM(NSInteger, SYRequestReachabilityStatus) {
    /// we don't know which kind of environment this devices is in
    SYRequestReachabilityStatusUnknow = 0,
    /// the device can not connect to the internet.
    SYRequestReachabilityStatusNotReachable,
    /// the device can use the internet by the mobile
    SYRequestReachabilityStatusViaWWAN,
    /// the device can use the internet by the wifi, which means the users are in the best internet environment
    SYRequestReachabilityStatusViaWiFi
};

@class SYRequest;
@class SYResponse;

/// success and failure blocks when we get the result from the AFNetwork and give the datas to the SYNetwork layer
typedef void(^SYCallBackSuccess)(SYResponse *response , NSError *error);
typedef void(^SYCallBackFail)(NSUInteger requestID ,NSError *error);

@interface SYHTTPManager : NSObject

/// the methods to get the singleton instance
+ (instancetype)sharedInstance;

/**
 to start the request, all kinds of requests are started from this method.
 in the future we will support a serialization requests, 
 maybe this mehtod would not be the only one or would be UNAVAILABLE

 @param request the request instance whitch provide the URL, the arguements and the request methods.
 @param success a block when the request is succeed
 @param fail a block when the request is failed
 @return return the NSURLSessionDataTask's tastIdentifier which can be used to cancle a request
 */
- (NSInteger)startRequest:(SYRequest *)request
                  success:(SYCallBackSuccess)success
                     fail:(SYCallBackFail)fail;


/**
 cancle a request according to the NSURLSessionDataTask's tastIdentifier

 @param requestID the id
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

/**
 cancle a list of requests according to a list of the NSURLSessionDataTask's tastIdentifier

 @param requestIDList a list of ids
 */
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

/// this properties is used to get tell the SYnetwork if the network is available
@property (nonatomic ,assign ,getter=isReachability) BOOL reachability;

///  
@property (nonatomic, assign, readonly) SYRequestReachabilityStatus reachabilityStatus;

@end
