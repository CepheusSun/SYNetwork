//
//  SYCache.m
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

#import "SYCache.h"
#import "SYCacheObject.h"
#import "SYRequestParametersBuilder.h"
#import "SYNetwork.h"
#import "SYRequestConfig.h"
#import "SYServiceFactory.h"

@interface SYCache ()

@property (nonatomic ,strong) NSCache *cache;

@end

@implementation SYCache
- (NSCache *)cache {
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = [[SYRequestConfig sharedConfig] cacheCountLimit];
    }
    return _cache;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SYCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SYCache alloc] init];
    });
    return sharedInstance;
}

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)identifier
                                             URL:(NSString *)URL
                                   requestParams:(NSDictionary *)requestParams {
    return  [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:identifier
                                                                    URL:URL
                                                          requestParams:requestParams]];
}

- (void)saveCacheWithServiceIdentifier:(NSString *)identifier
                                  Data:(NSData *)cachedData
                                   URL:(NSString *)URL
                         requestParams:(NSDictionary *)requestParams {
    
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:identifier
                                                                      URL:URL
                                                            requestParams:requestParams]];
}

- (void)deleteCacheServiceIdentifier:(NSString *)identifier
                             WithURL:(NSString *)URL
                       requestParams:(NSDictionary *)requestParams {
    
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:identifier
                                                        URL:URL
                                              requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key {
    SYCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    }
    return cachedObject.content;
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key {
    SYCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[SYCacheObject alloc] initWithContent:cachedData];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key {
    [self.cache removeObjectForKey:key];
}

- (void)clean {
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)identifier
                                   URL:(NSString *)URL
                         requestParams:(NSDictionary *)requestParams {
    
    NSDictionary *serviceStorage = [SYRequestConfig sharedConfig].serviceStorage;
    SYRequestParametersBuilder *builder = [[SYServiceFactory sharedInstance] serviceWithIdentifier:serviceStorage[identifier]].requestParametersBuilder;
    
    return [NSString stringWithFormat:@"%@%@",URL ,[builder cacheSaveKeyString:requestParams]];
}

@end
