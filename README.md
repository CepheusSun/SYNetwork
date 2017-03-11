# SYNetwork

[![CI Status](http://img.shields.io/travis/孙扬/SYNetwork.svg?style=flat)](https://travis-ci.org/孙扬/SYNetwork)
[![Version](https://img.shields.io/cocoapods/v/SYNetwork.svg?style=flat)](http://cocoapods.org/pods/SYNetwork)
[![License](https://img.shields.io/cocoapods/l/SYNetwork.svg?style=flat)](http://cocoapods.org/pods/SYNetwork)
[![Platform](https://img.shields.io/cocoapods/p/SYNetwork.svg?style=flat)](http://cocoapods.org/pods/SYNetwork)


Easy and light Network framework based on AFNetwork for iOS.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 2.1 新特性

版本移除了在2.0中新增的 SYRequestParametersBuilder 类,将参数加工的相关方法移动到 SYService 及其子类中进行。 将产生 缓存 key 的方法移动的缓存类中,不开放给业务层。

## 2.0 新特性

**增加 service 支持**，不同的 service 可以有不同的 baseUrl 也可以有不同的 apiversion 也可以使用不同的 appkey。

对应 `AppDelegate `中的方法对应修改

```objective-c
[[SYRequestConfig sharedConfig] configTimeOutInterval:20
                                      cacheCountLimit:1000
                            serviceStorage:@{@"TestTypeOne" : @"TestService"}];
```

对应的在继承于 `SYService`的 `service`字类中添加相应的属性。可以参考 demo 


并且为了做出对应修改，**在`SYRequest`基类中添加对应方法设置 这个api 所属的 service** 。对应在之类中只需要添加对应方法。

```objective-c
- (NSString *)serviceType {
    return @"TestTypeOne";
}

```

**SYService** 中添加

```objective-c
- (SYRequestParametersBuilder *)requestParametersBuilder {
    return [TESTRequestParameterBuilder sharedInstance];
}
```

相关方法，将签名相关的类，移动到这个地方，实现不同的service可以有不同的签名规则。

## 原理

### 组成

SYNetwork 由下面两个部分组成

* SYNetwork

 ~~SYRequestParametersBuilder~~

    > ~~这个类可以添加一些公共的参数~~  已经废弃,相关功能已到 SYService 类中

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

* SYLogger

 > 一个漂亮的Logger


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
    [[SYRequestConfig sharedConfig] configTimeOutInterval:20
                                          cacheCountLimit:1000
                                           serviceStorage:@{@"TestTypeOne" : @"TestService"}];

```

~~以上代码中的`XXRequestParametersBuilder` 是`SYRequestParametersBuilder`的子类,主要有以下方法~~

```objective-c
+ (SYRequestParametersBuilder *)sharedInstance;

- (NSDictionary *)rebuildParameters:(NSDictionary *)parameters;

/**
 生成缓存的key  这个方法必须由字类实现  移除后这个key直接由框架内部产生, 不需要再由业务层规定
 
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


