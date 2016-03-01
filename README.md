# Mercurio

[![CI Status](http://img.shields.io/travis/Stefano Zanetti/Mercurio.svg?style=flat)](https://travis-ci.org/Stefano Zanetti/Mercurio)
[![Version](https://img.shields.io/cocoapods/v/Mercurio.svg?style=flat)](http://cocoapods.org/pods/Mercurio)
[![License](https://img.shields.io/cocoapods/l/Mercurio.svg?style=flat)](http://cocoapods.org/pods/Mercurio)
[![Platform](https://img.shields.io/cocoapods/p/Mercurio.svg?style=flat)](http://cocoapods.org/pods/Mercurio)

Mercurio is a fast way to make an api with [AFNetworking](https://github.com/AFNetworking/AFNetworking) and parse the response with [Mantle](https://github.com/Mantle/Mantle).

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Mercurio is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Mercurio', '~> 0.1.3'
```

## Example
##### Define a response object

```objective-c
@interface MEResponse : MEModel

@property (copy, nonatomic) NSString *accept;
@property (copy, nonatomic) NSString *acceptEncoding;
@property (copy, nonatomic) NSString *acceptLanguage;
@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *userAgent;

@end

```

```objective-c
@implementation MEResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ selStr(accept) : @"Accept",
              selStr(acceptEncoding) : @"Accept-Encoding",
              selStr(acceptLanguage) : @"Accept-Language",
              selStr(host) : @"Host",
              selStr(userAgent) : @"User-Agent" };
}

@end

```
#### GET
You must create an instance of MEApi, set the path, the class response and eventually the root of json response object. That's all!

```objective-c
MEApi *api = [MEApi apiWithMethod:MEApiMethodGET
                             path:@"https://httpbin.org/get"
                    responseClass:[MEResponse class]
                         jsonRoot:@"headers"];
```

Now you simple have to tell the MESessionManager which API you want execute and nothing else.

```objective-c    
[[MESessionManager sharedInstance] sessionDataTaskWithApi:api
                                               completion:^(id responseObject, NSURLSessionDataTask *task, NSError *error) {
                                                   if (!error) {
                                                       NSLog(@"%@", responseObject);
                                                   }
                                               }];

```

##### POST Multipart
Like the previous example, you must create an instance of MEMultipartFormApi. MEMultipartFormApi is a MEApi that is conformed to the MEMultipartFormApiProtocol protocol.

```objective-c
MEMultipartFormApi *api = [MEMultipartFormApi apiWithMethod:MEApiMethodPOST
                                                       path:@"http://posttestserver.com/post.php?dir=mercurio"
                                              responseClass:[NSNull class]
                                                   jsonRoot:nil];
    
[api setMultipartFormConstructingBodyBlock:^(id<AFMultipartFormData> formData) {
       [formData appendPartWithFileData:[NSData data]
                                   name:@""name"
                               fileName:@"file.jpg"
                               mimeType:@"image/jpeg"];
}];
```

And then the MESessionManager does the rest.


```objective-c    
[[MESessionManager sharedInstance] sessionMultipartDataTaskWithApi:api
                                                        completion:^(id responseObject, NSURLSessionDataTask *task, NSError *error) {    
                                                            if (!error) {
                                                                NSLog(@"%@", responseObject);
                                                            }
                                                        }];

```

MESessionManager always returns a NSURLSessionDataTask so you can cancel the operation at any time.


## Author

Stefano Zanetti, stefano.zanetti@pragmamark.org

## License

Mercurio is available under the MIT license. See the LICENSE file for more info.
