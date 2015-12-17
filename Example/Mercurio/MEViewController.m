//
//  MEViewController.m
//  Mercurio
//
//  Created by Stefano Zanetti on 10/27/2015.
//  Copyright (c) 2015 Stefano Zanetti. All rights reserved.
//

#import "MEViewController.h"
#import <MEApi.h>
#import <MEMultipartFormApi.h>
#import <MESessionManager.h>
#import "MEResponse.h"

@interface MEViewController ()

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation MEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logTextView.text = @"Waiting for a responce...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self testMultipartPost];
}

- (void)testGetApi {
    MEApi *api = [MEApi apiWithMethod:MEApiMethodGET
                                 path:@"https://httpbin.org/get"
                        responseClass:[MEResponse class]
                             jsonRoot:@"headers"];
    
    
    [[MESessionManager sharedInstance] sessionDataTaskWithApi:api
                                                   completion:^(id responseObject, NSURLSessionDataTask *task, NSError *error) {
                                                       NSLog(@"%@", responseObject);
                                                       _logTextView.text = error ? [error localizedDescription] : [responseObject description];
                                                   }];
}

- (void)testMultipartPost {
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [[MESessionManager sharedInstance] setResponseSerializer:responseSerializer];
    
    NSArray *files = @[ UIImageJPEGRepresentation([self screenshot], 0.4) ];
    
    MEMultipartFormApi *api = [MEMultipartFormApi apiWithMethod:MEApiMethodPOST
                                                           path:@"http://posttestserver.com/post.php?dir=mercurio"
                                                  responseClass:[NSNull class]
                                                       jsonRoot:@"headers"];
    
    [api setMultipartFormConstructingBodyBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        for (NSData *data in files) {
            [formData appendPartWithFileData:data
                                        name:[NSString stringWithFormat:@"name_%i", i]
                                    fileName:[NSString stringWithFormat:@"file_%i.jpg", i]
                                    mimeType:@"image/jpeg"];
            i++;
        }
    }];
    
    [[MESessionManager sharedInstance] sessionDataTaskWithApi:api
                                                   completion:^(id responseObject, NSURLSessionDataTask *task, NSError *error) {
                                                       
                                                       if (error) {
                                                           _logTextView.text = [error localizedDescription];
                                                       } else {
                                                           id object = responseObject;
                                                           
                                                           if ([responseObject isKindOfClass:[NSData class]]) {
                                                               object = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                               NSLog(@"%@", object);
                                                           } else {
                                                               NSLog(@"%@", responseObject);
                                                           }
                                                           
                                                           _logTextView.text = object;
                                                       }
                                                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)screenshot {
    CGSize size = self.view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rec = CGRectMake(0, 0, size.width, size.height);
    [self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
