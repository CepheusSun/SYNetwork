//
//  SYCacheObject.m
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

#import "SYCacheObject.h"
#import "SYNetwork.h"
#import "SYRequestConfig.h"
@interface SYCacheObject ()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;

@end
@implementation SYCacheObject

- (BOOL)isEmpty {
    return self.content == nil;
}

- (BOOL)isOutdated {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > [[SYRequestConfig sharedConfig] timeOutInterval];
}

- (void)setContent:(NSData *)content {
    _content = content;
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

- (instancetype)initWithContent:(NSData *)content {
    self =[super init];
    if (self) {
        self.content = content;
    }
    return self;
}

- (void)updateContent:(NSData *)content {
    self.content = content;
}
@end
