//
//  NSDictionary+SYNetworking.m
//  SYNetworking
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

#import "NSDictionary+SYNetworking.h"
#import "NSString+Encryption.h"

static NSString *const DPHUUID = @"DPHUUIDSVAE";

@implementation NSDictionary (SYNetworking)

- (NSString *)keyString {
    return [self sortedWithPublicKey:@""];
}

- (NSMutableDictionary *)signWithPublicKey:(NSString *)publicKey {
    NSMutableDictionary *mutableSelf = self.mutableCopy;
    [mutableSelf setObject:[NSString stringWithFormat:@"%ld",time(NULL)] forKey:@"rdateline"];

    [mutableSelf setValue:[self UUID] forKey:@"uuid"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    [mutableSelf setValue:[infoDic objectForKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    [mutableSelf setObject:[[[[mutableSelf sortedWithPublicKey:publicKey] SY_base_64] SY_md5] SY_md5] forKey:@"isign"];
    return mutableSelf;
}

- (NSString *)sortedWithPublicKey:(NSString *)publicKey {
    NSArray *sortedArray = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
    __block NSString *sortedString = @"";
    [sortedArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sortedString = [sortedString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[obj lowercaseString],self[obj]]];
    }];
    return [NSString stringWithFormat:@"%@%@",sortedString,publicKey];
}

- (NSString *)UUID{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:DPHUUID]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:DPHUUID];
    }else {
        CFUUIDRef uuid_ref = CFUUIDCreate(nil);
        CFStringRef uuid_string_ref= CFUUIDCreateString(nil, uuid_ref);
        CFRelease(uuid_ref);
        NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
        CFRelease(uuid_string_ref);
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:DPHUUID];
        return uuid;
    }
}
@end
