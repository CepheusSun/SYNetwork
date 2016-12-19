//
//  SYServiceFactory.m
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

#import "SYServiceFactory.h"
#import "SYRequestConfig.h"

@interface SYServiceFactory()

@property (nonatomic ,strong) NSMutableDictionary *serviceStorage;
@end
@implementation SYServiceFactory

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage {
    
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static SYServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SYServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (SYService<SYServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier {

    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

- (SYService<SYServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier {
    NSDictionary *serviceStorage = [[SYRequestConfig sharedConfig] serviceStorage];
    if (serviceStorage) {
        NSString *classString = serviceStorage[identifier];
        return [[NSClassFromString(classString) alloc] init];
    }
    return nil;
}



@end
