//
//  SYApiManager.m
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

#import "SYRequest.h"
#import "SYCache.h"
#import "SYHTTPManager.h"
#import "SYResponse.h"
#import "SYRequestConfig.h"
#import "SYLogger.h"

@interface SYRequest ()

@property (nonatomic ,copy) SYRequestFinishedBlock failureBlock;
@property (nonatomic ,copy) SYRequestFinishedBlock succeddBlock;

@property (nonatomic ,strong) NSMutableArray *requestIDList;
@property (nonatomic ,strong) SYCache *cahce;

@end

@implementation SYRequest

- (void)dealloc {
    [self cancelAllRequest];
    self.requestIDList = nil;
}
- (SYCache *)cahce {
    if (!_cahce) {
        _cahce = [SYCache sharedInstance];
    }
    return _cahce;
}
#pragma mark - cancel
- (void)cancelAllRequest {
    [[SYHTTPManager sharedInstance] cancelRequestWithRequestIDList:self.requestIDList];
    [self.requestIDList removeAllObjects];
}

- (void)cancelRequestWithrequestId:(NSInteger)requrstId {
    [self removeRequestIdWithRequestID:requrstId];
    [[SYHTTPManager sharedInstance] cancelRequestWithRequestID:@(requrstId)];
}

#pragma mark - calling api
- (NSInteger)start {
    if ([self shouldCache] && [self hasCacheWithParams:self.requestParams]) {
        return 0;
    }
    NSInteger requestId = -1;
    if ([SYHTTPManager sharedInstance].isReachability) {
        __weak typeof(self) weakSelf = self;
        requestId = [[SYHTTPManager sharedInstance] startRequest:self success:^(SYResponse *response, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf successOnCallingApi:response];
        } fail:^(NSUInteger requestID, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf failureOnCallingApi:requestID withError:error];
        }];
        NSMutableDictionary *params = [self.requestParams mutableCopy];
        params[kAPIBaseManagerRequestID] = @(requestId);
        return requestId;
    }else {
        [self failureOnCallingApi:requestId withError:[[NSError alloc] initWithDomain:@"网络链接失败" code:-10000 userInfo:nil]];
    }
    return requestId;
}

- (NSInteger)startWithSuccessBlock:(SYRequestFinishedBlock)success
                      failureBlbck:(SYRequestFinishedBlock)failure; {
    [self setupSuccessBlock:success failureBlock:failure];
    return [self start];
}

- (void)setupSuccessBlock:(SYRequestFinishedBlock)success
             failureBlock:(SYRequestFinishedBlock)fail {
    self.succeddBlock = success;
    self.failureBlock = fail;
}

- (void)clearCompletionBlock {
    self.succeddBlock = nil;
    self.failureBlock = nil;
}

- (void)successOnCallingApi:(SYResponse *)response {
    [self removeRequestIdWithRequestID:response.requestId];
    NSError *error = [self isResponseIllegal:response];
    if (error == nil) {
        [self callBackSuccess:response];
    }else {
        [self callBackFailure:error];
        return;
    }
    if ([self shouldCache]) {
        [self.cahce saveCacheWithData:response.responseData URL:self.requestUrl requestParams:self.requestParams];
    }
}

- (void)failureOnCallingApi:(NSUInteger)requestID withError:(NSError *)error {
    [self removeRequestIdWithRequestID:requestID];
    [self callBackFailure:error];
}

- (void)callBackSuccess:(SYResponse *)response {
    if (self.callBackDelegate && [self.callBackDelegate respondsToSelector:@selector(managerCallApiDidSuccess:)]) {
        [self.callBackDelegate managerCallApiDidSuccess:response];
    }else {
        if (self.succeddBlock) {
            self.succeddBlock(response,nil);
        }
    }
    [self clearCompletionBlock];
}

- (void)callBackFailure:(NSError *)error {
    NSError *aError = makeError(error);
    if (self.callBackDelegate && [self.callBackDelegate respondsToSelector:@selector(managerCallApiDidFailed:)]) {
        [self.callBackDelegate managerCallApiDidFailed:aError.localizedDescription];
    }else {
        if (self.failureBlock) {
            self.failureBlock(nil,aError.domain);
        }
    }
    [self clearCompletionBlock];
}

NSError *makeError(NSError *error){
    if (error.code != -10000) {
        return [[NSError alloc] initWithDomain:error.localizedDescription code:error.code userInfo:error.userInfo];
    }
    return error;
}
#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIDList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIDList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params {
    NSData *data = [self.cahce fetchCachedDataWithURL:self.requestUrl requestParams:self.requestParams];
    if (data == nil) {
        return NO;
    }
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        SYResponse *response = [[SYResponse alloc] initWithData:data];
        response.requestParams = params;
        [SYLogger logDebugInfoWithCachedResponse:response request:self];
        if (strongSelf.callBackDelegate && [strongSelf.callBackDelegate respondsToSelector:@selector(managerCallApiDidSuccess:)]) {
            [strongSelf.callBackDelegate managerCallApiDidSuccess:response];
        }else {
            if (self.succeddBlock) {
                self.succeddBlock(response,nil);
            }
        }
    });
    return YES;
}

#pragma override
- (BOOL)shouldCache {
    return NO;
}

-(BOOL)useCDN {
    return NO;
}

- (NSString *)requestUrl {
    return @"";
}
- (SYRequestType)requestType {
    return SYRequestPost;
}

- (NSMutableDictionary *)requestParams {
    return @{}.mutableCopy;
}
//在子类别中进行处理
- (NSError *)isResponseIllegal:(SYResponse *)response{
    return nil;
}
@end
