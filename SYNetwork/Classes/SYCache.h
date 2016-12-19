//
//  SYCache.h
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

// 缓存工具类
@interface SYCache : NSObject

+ (instancetype)sharedInstance;

- (NSString *)keyWithServiceIdentifier:(NSString *)identifier
                                   URL:(NSString *)URL
                         requestParams:(NSDictionary *)requestParams;

/**
 获得缓存的对象

 @param URL 请求地址
 @param requestParams 请求参数
 @return 缓存对象
 */
- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)identifier
                                             URL:(NSString *)URL
                                   requestParams:(NSDictionary *)requestParams;


/**
 存储网络请求的数据

 @param cachedData 需要缓存的内容
 @param URL 请求地址
 @param requestParams 请求参数
 */
- (void)saveCacheWithServiceIdentifier:(NSString *)identifier
                                  Data:(NSData *)cachedData
                                   URL:(NSString *)URL
                         requestParams:(NSDictionary *)requestParams;


/**
 根据参数方法名和参数删除本地缓存
 @param URL 请求地址
 @param requestParams 请求参数
 */
- (void)deleteCacheServiceIdentifier:(NSString *)identifier
                             WithURL:(NSString *)URL
                       requestParams:(NSDictionary *)requestParams;



/**
 通过key 获得缓存对象

 @param key key值
 @return 缓存的对象
 */
- (NSData *)fetchCachedDataWithKey:(NSString *)key;

/**
 根据key 缓存

 @param cachedData 缓存的对象
 @param key key
 */
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key;

/**
 根据key删除缓存

 @param key key值
 */
- (void)deleteCacheWithKey:(NSString *)key;

/**
 清空缓存
 */
- (void)clean;

@end
