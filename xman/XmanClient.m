//
//  XmanClient.m
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "XmanClient.h"

NSString *baseUrlString = @"https:";

@implementation XmanClient

+(XmanClient *)sharedClient
{
    static XmanClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    });
    
    return _sharedClient;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(self)
    {
//        self.responseSerializer = [JSONResponseSerializerWithData serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = 10;
        self.xmanCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                            diskCapacity:50 * 1024 * 1024
                                                                diskPath:nil];
        [NSURLCache setSharedURLCache:self.xmanCache];
//        [self.reachabilityManager startMonitoring];
    }
    return self;
}

@end
