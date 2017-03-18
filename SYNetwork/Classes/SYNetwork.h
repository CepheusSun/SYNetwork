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

/**** SYNetwork 使用指南
 
 ### step 1
 1. 使用 CocoaPods 添加 pod ‘SYNetwork’ 在终端执行 pod install 命令
 2. 在 PCH 文件中添加 #import <SYNetwork/SYNetwork.h>
 
 以上两个步骤纯属科普, 如果不会弄, 建议先查一下
 
 ### step 2
 1. 添加你自己的 Service 类, 这个类主要是用来配置这个 Service 的。 一个 Service 应该具有自己的 api 版本 自己的 加密 解密规则 以及自己的 baseurl
    1. 添加自己的 Service 类应该继承 SYService 对象。 然后对应的重写相关方法。

 2. 在 Appdelegte 的 application:didFinishLaunchingWithOptions 方法中注册 Service 和配置一些基本的东西
 
 ```
 [[SYRequestConfig sharedConfig] configTimeOutInterval:20
                                       cacheCountLimit:1000
                                        serviceStorage:@[ @"TestService" ]];
 
 这段代码分别设置了请求超时时间， 缓存的最大容量， 和一个 Service 数组。这里只需要写自定义的 Service 类。
 ```
 
 3. 由于采用离散型的请求方式。我们对应的每个请求都是一个类。 在这个类中涉及到的就是业务层需要提供的内容。 请求方式(GET\POST)、 缓存时间，请求地址，结果合法性校验。还有最重要的参数balabala
        由于很多 app 其实合法性校验都差不多，可以对应的写一些 业务层的 基类。这个类应该最终继承自 SYRequest
 
 
 ### step 3
 业务层如何具体发起请求。
 1. 无论在 Model 或者是 ViewModel 里，增加一个对应的成员变量。然后在需要发起请求的时候，对应的初始化这个对象，然后相关的属性赋值。然后 start 或者 startWithBlock。 就可以了
 
 2. 发起请求, 就可以看到我提供的漂亮的 logger 了
*/

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif
#import "SYService.h"
#import "SYResponse.h"
#import "SYRequestConfig.h"
#import "SYRequest.h"

#endif /* SYNetwork_h */
