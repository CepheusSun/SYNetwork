//
//  SYRequesrCenter.m
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

#import "SYHTTPManager.h"
#import "SYNetwork.h"
#import "SYResponse.h"
#import "SYRequest.h"
#import "SYRequestParametersBuilder.h"
#import "SYLogger.h"
#import "SYServiceFactory.h"

@interface SYHTTPManager ()

@property (nonatomic ,strong) NSMutableDictionary *dispatchTable;
@property (nonatomic ,strong) NSNumber *recordedRequesdID;
@property (nonatomic ,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic ,assign) NSUInteger *currentRequestCount;
@end
@implementation SYHTTPManager

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes =
        [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", @"text/javascript", nil];
        // 限制最大请求量
        self.sessionManager.operationQueue.maxConcurrentOperationCount = 5;
    }
    return _sessionManager;
}

+ (instancetype)sharedInstance {
    static SYHTTPManager *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[SYHTTPManager alloc] init];
        [center startNetworkStateMonitoring];
    });
    return center;
}

- (NSInteger)startRequest:(SYRequest *)request
                  success:(SYCallBackSuccess)success
                     fail:(SYCallBackFail)fail {
    __block NSURLSessionDataTask *dataTask = nil;
    self.currentRequestCount ++;
    switch ([request requestType]) {
        case SYRequestPost:
        {
            __weak typeof(self) weakSelf = self;
            dataTask = [self.sessionManager POST:makeFullUrl(request) parameters:makeFullParameters(request) progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                SYResponse *resp = [[SYResponse alloc] initWithRequestId:@([task taskIdentifier])
                                                            responseData:responseObject
                                                                   error:nil];
                weakSelf.currentRequestCount --;
                [SYLogger logDebugInfomationDataTask:task request:request response:resp];

                success(resp ,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                weakSelf.currentRequestCount --;
                [SYLogger logDebugInfomationDataTask:task request:request error:error];
                fail([task taskIdentifier] ,error);
            }];
        }
            break;
        case SYRequestGet:
        {
            __weak typeof(self) weakSelf = self;
            dataTask = [self.sessionManager GET:makeFullUrl(request) parameters:makeFullParameters(request) progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [SYLogger logDebugInfomationDataTask:task request:request response:responseObject];
                SYResponse *resp = [[SYResponse alloc] initWithRequestId:@([task taskIdentifier])
                                                            responseData:responseObject
                                                                   error:nil];
                weakSelf.currentRequestCount --;
                success(resp ,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SYLogger logDebugInfomationDataTask:task request:request error:error];
                weakSelf.currentRequestCount --;
                fail([task taskIdentifier] ,error);
            }];
        }
            break;
    }
    NSNumber *requestID = @([dataTask taskIdentifier]);
    self.dispatchTable[requestID] = dataTask;
    [dataTask resume];
    return [requestID integerValue];
}

#pragma mark - cancel request
- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    self.currentRequestCount --;
    NSURLSessionTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (void)setCurrentRequestCount:(NSUInteger *)currentRequestCount {
    _currentRequestCount = currentRequestCount;
    if (currentRequestCount > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}

#pragma mark - private
NSString* makeFullUrl(SYRequest *request) {

    NSString *url = [[[SYServiceFactory sharedInstance] serviceWithIdentifier:request.serviceType] baseUrl];
    NSString *apiVersion = [[[SYServiceFactory sharedInstance] serviceWithIdentifier:request.serviceType] apiVersion];
    
    return [NSString stringWithFormat:@"%@%@%@",url,apiVersion,request.requestUrl];
}

NSDictionary* makeFullParameters(SYRequest *request) {

    return [[[[SYServiceFactory sharedInstance] serviceWithIdentifier:request.serviceType] requestParametersBuilder] rebuildParameters:request];
}

#pragma mark - 监测网络状态
-(BOOL)isReachability {
    if (self.reachabilityStatus != SYRequestReachabilityStatusNotReachable) {
        return YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    return NO;
}

- (void)startNetworkStateMonitoring {
    [self.sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                _reachabilityStatus = SYRequestReachabilityStatusUnknow;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _reachabilityStatus = SYRequestReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _reachabilityStatus = SYRequestReachabilityStatusViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _reachabilityStatus = SYRequestReachabilityStatusViaWiFi;
                break;
            default:
                break;
        }
    }];
    [self.sessionManager.reachabilityManager startMonitoring];
}

@end
