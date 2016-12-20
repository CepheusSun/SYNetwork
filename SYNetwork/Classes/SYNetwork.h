//
//  SYNetwork.h
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

#ifndef SYNetwork_h
#define SYNetwork_h


/**
 SYRequestConfig:
 - (void)configBaseUrl:(NSString *)base
 timeOutInterval:(NSTimeInterval)timeout
 cacheCountLimit:(NSUInteger)cacheCountLimit
 rebuildParametersManger:(SYRequestParametersBuilder*)rebuildParametersManager;
 在 Appdelegate 中通过这个方法 配置 SYNetwork 全局配置, 如:
 
 [[SYRequestConfig sharedConfig] configBaseUrl:BASE_URL timeOutInterval:20 cacheCountLimit:1000 rebuildParametersManger:[DPHRequestParametersBuilder sharedInstance]];
 
 创建一个 SYRequestParametersBuilder 的子类，这是用来做签名的。
 */


#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif
#import "SYService.h"
#import "SYResponse.h"
#import "SYRequestConfig.h"

#endif /* SYNetwork_h */
