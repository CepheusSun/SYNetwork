//
//  SYBaseRequest.h
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

static NSString * const kAPIBaseManagerRequestID = @"kAPIBaseManagerRequestID";

typedef NS_ENUM (NSUInteger, SYAPIErrorType){
    SYAPIErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    SYAPIErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    SYAPIErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    SYAPIErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    SYAPIErrorTypeTimeout,       //请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    SYAPIErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, SYRequestType){
    SYRequestGet,
    SYRequestPost
};

@class SYRequest;
@class SYResponse;
/*********************************************************************************/
/*                                 callBack回调                                   */
/*********************************************************************************/

//delegate
@protocol SYRequestCallBackDelegate <NSObject>
@required
- (void)managerCallApiDidSuccess:(SYResponse *)response;
- (void)managerCallApiDidFailed:(NSString *)errorMessage;
@end
//block
typedef void(^SYRequestFinishedBlock)(SYResponse *response, NSString *errorMessage);

@interface SYRequest : NSObject

@property (nonatomic ,weak) id <SYRequestCallBackDelegate> callBackDelegate;

#pragma mark ---- override by child
- (NSString *)requestUrl;//  请求URL
- (SYRequestType)requestType;// default POST
- (NSUInteger)cacheTimeInterval; //是否缓存 default NO
- (NSString *)serviceType;
- (NSMutableDictionary *)requestParams;// 请求参数
- (NSError *)isResponseIllegal:(SYResponse *)response; // 对数据进行校验，并对数据业务逻辑的失败进行处理
//开始请求
- (NSInteger)start;
- (NSInteger)startWithSuccessBlock:(SYRequestFinishedBlock)success
                      failureBlbck:(SYRequestFinishedBlock)failure;

// 取消请求
- (void)cancelAllRequest;
- (void)cancelRequestWithrequestId:(NSInteger)requrstId;
@end
