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


// A tool about caches of SYNetwork. this class is NOT OPEN for business layer
@interface SYCache : NSObject

/// get the singleton instance of SYCache
+ (instancetype)sharedInstance;

/**
 this method use to create the key to cache the datas, 
 this key is make of the service identifier the URL and the request params.
 this is a NSString instance

 @param identifier identifier if the request
 @param URL the URL
 @param requestParams the request arguements
 @return the key to save the caches
 */
- (NSString *)keyWithServiceIdentifier:(NSString *)identifier
                                   URL:(NSString *)URL
                         requestParams:(NSDictionary *)requestParams;

/**
 fetch cached data

 @param identifier the identifier of the request
 @param URL the URL
 @param requestParams the request arguements
 @return cached data
 */
- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)identifier
                                             URL:(NSString *)URL
                                   requestParams:(NSDictionary *)requestParams;

/**
 save the caches of SYNetwork response

 @param identifier the identifier of the request
 @param cachedData the data which need to be cached
 @param URL the request URL
 @param requestParams the requesr arguements
 */
- (void)saveCacheWithServiceIdentifier:(NSString *)identifier
                                  Data:(NSData *)cachedData
                                   URL:(NSString *)URL
                         requestParams:(NSDictionary *)requestParams;

/**
 delete the caches when it is useless or overtime

 @param identifier the identifier if the request
 @param URL the URL
 @param requestParams the request arguements
 */
- (void)deleteCacheServiceIdentifier:(NSString *)identifier
                             WithURL:(NSString *)URL
                       requestParams:(NSDictionary *)requestParams;


/**
 fetch the data according to the key

 @param key this key string
 @return the cached data
 */
- (NSData *)fetchCachedDataWithKey:(NSString *)key;


/**
 caches the data according to the key string

 @param cachedData the data which needed to be cached
 @param key the key string
 */
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key;

/**
 delete the cached data according to the key

 @param key the key string
 */
- (void)deleteCacheWithKey:(NSString *)key;

/**
 clean the cached data
 */
- (void)clean;

@end
