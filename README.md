# SYNetwork

[![CI Status](http://img.shields.io/travis/孙扬/SYNetwork.svg?style=flat)](https://travis-ci.org/孙扬/SYNetwork)
[![Version](https://img.shields.io/cocoapods/v/SYNetwork.svg?style=flat)](http://cocoapods.org/pods/SYNetwork)
[![License](https://img.shields.io/cocoapods/l/SYNetwork.svg?style=flat)](http://cocoapods.org/pods/SYNetwork)
[![Platform](https://img.shields.io/cocoapods/p/SYNetwork.svg?style=flat)](http://cocoapods.org/pods/SYNetwork)



Easy and light Network framework based on AFNetwork for iOS.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## 原理

### 组成

SYNetwork 由下面两个部分组成

* SYNetwork

  * SYRequestParametersBuilder

    > 这个类可以添加一些公共的参数

  * SYRequest

    > 所有网络请求 API 的父类

  * SYNetworkConfig

    > 环境配置 包括网络请求的 BaseUrl 请求超时时间，缓存总量等

  * SYHTTPManager

    > 所有网络请求统一由这个类发出

  * SYResponse

    > 网络请求返回值对象

* SYCache

  - SYCache

    > 缓存管理

  - SYCacheObject 

    > 缓存的对象



## 加入

#### 1、直接将源文件拉进你的工程

#### 2、SYNetwork也支持通过[*Cocoapod*](http://cocoapods.org). 通过在Podfile中添加如下代码。

```ruby
pod "SYNetwork"
```

然后在终端中运行

```ruby
pod install
```

## 使用方法

### step 1

导入头文件

```objective-c
#import <SYNetwork/SYNetwork.h>
```

在`appdelegate`中加入如下代码

```objective-c
[[SYRequestConfig sharedConfig] configBaseUrl:YOUR_BASE_URL                                            								 timeOutInterval:20
                              cacheCountLimit:1000
                      rebuildParametersManger:[XXRequestParametersBuilder sharedInstance]];

```

以上代码中的`XXRequestParametersBuilder` 是`SYRequestParametersBuilder`的子类,主要有以下方法

```objective-c
+ (SYRequestParametersBuilder *)sharedInstance;

- (NSDictionary *)rebuildParameters:(NSDictionary *)parameters;

/**
 生成缓存的key  这个方法必须由字类实现
 
 @param parcmeters 参数
 @return key
 */
- (NSString *)cacheSaveKeyString:(NSDictionary *)parcmeters;
```



#### step 2

每个接口都是一个继承与`SYRequest`的子类,接下来以登录为例子

**LoginApi.h**

```objective-c
- (id)initWithUserName:(NSString *)username password:(NSString *)password;
```

**LoginApi.m**

```objective-c
@implementation LoginApi{
    NSString *_username;
    NSString *_password;
}

- (id)initWithUserName:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
        _logintype = logintype;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"api/user/login";
}

- (NSMutableDictionary *)requestParams {
    return @{
             @"phone": _username,
             @"code" : _password,
             }.mutableCopy;
}
```

还可以通过`SYRequest`的一些方法,来设置请求方法，校验返回收据，是否缓存等问题。

### step 3 调用

通过`block`

```objective-c
    _loginApi = [[LoginApi alloc] initWithUserName:phone password:code logintype:type];
    [_loginApi startWithSuccessBlock:^(SYResponse *response , NSString *errorMessage) {
       // 请求成功
    } failureBlbck:^(SYResponse *response , NSString *errorMessage) {
	   // 请求失败
    }];
```



也可以通过`delegate`收到回调

```objective-c
    _loginApi = [[LoginApi alloc] initWithUserName:phone password:code logintype:type];
	_loginApi.callBackDelegate = self;
	[_loginApi start];
```

然后实现

```objective-c
- (void)managerCallApiDidSuccess:(SYResponse *)response;
- (void)managerCallApiDidFailed:(NSString *)errorMessage;
```

两个方法

## License

SYNetwork is available under the MIT license. See the LICENSE file for more info.
