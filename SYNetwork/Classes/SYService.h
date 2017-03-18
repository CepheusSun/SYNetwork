//
//  SYService.h
//  SYNetwork
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

@interface SYService : NSObject


@property (nonatomic ,copy) NSString *apiVersion;
@property (nonatomic ,copy) NSString *baseUrl;

// 拼接 参数 加密等动作
- (NSDictionary *)makeParams:(NSDictionary *)originParams;

// 业务层需要自定义 Body 的时候使用
- (NSMutableURLRequest *)makeUrlRequest:(NSString *)url originParams:(NSDictionary *)originParams;

// 对服务器返回的数据进行解密
- (NSData *)decodeResponseObject:(id)responseObject;

@end
