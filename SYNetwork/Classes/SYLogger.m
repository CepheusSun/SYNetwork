//
//  SYLogger.m
//  demoo
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

#import "SYLogger.h"
#import "SYRequest.h"
#import "SYResponse.h"

@implementation SYLogger


+ (void)logDebugInfomationDataTask:(NSURLSessionDataTask *)dataTask
                           request:(SYRequest *)request
                          response:(SYResponse *)response {
    NSMutableString *logString = [NSMutableString stringWithString:
                                  @"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", dataTask.currentRequest.URL];
    [logString appendFormat:@"Method:\t\t\t%lu\n", (unsigned long)request.requestType];
    [logString appendFormat:@"Params:\n%@", request.requestParams];
    [logString appendFormat:@"Response:\n%@", response.content];
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendFormat:@"\nHTTP Header:\n%@", dataTask.currentRequest.allHTTPHeaderFields ? dataTask.currentRequest.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [logString appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:dataTask.currentRequest.HTTPBody encoding:NSUTF8StringEncoding]];
    
    
    [logString appendFormat:
     @"\n\n**************************************************************\n*                         Request End                       *\n**************************************************************\n\n\n\n"];
    
    printf("%s", [logString UTF8String]);
}

+ (void)logDebugInfomationDataTask:(NSURLSessionDataTask *)dataTask
                           request:(SYRequest *)request
                             error:(NSError *)error {
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", dataTask.currentRequest.URL];
    [logString appendFormat:@"Method:\t\t\t%lu\n", (unsigned long)request.requestType];
    [logString appendFormat:@"Params:\n%@", request.requestParams];
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];

    [logString appendFormat:@"\n\nHTTP Header:\n%@", dataTask.currentRequest.allHTTPHeaderFields ? dataTask.currentRequest.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [logString appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:dataTask.currentRequest.HTTPBody encoding:NSUTF8StringEncoding]];
    
    
    [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
    [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
    [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
    [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
    [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    
    
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    printf("%s", [logString UTF8String]);
}

+ (void)logDebugInfoWithCachedResponse:(SYResponse *)response
                               request:(SYRequest *)request {
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    [logString appendFormat:@"API Name:\t\t%@\n",request.requestUrl];
    [logString appendFormat:@"Params:\n%@\n\n" ,response.requestParams];
    [logString appendFormat:@"Contents:\n\t%@\n\n",response.content];
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    printf("%s", [logString UTF8String]);
    
}


@end
