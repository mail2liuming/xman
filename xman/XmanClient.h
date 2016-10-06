//
//  XmanClient.h
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface XmanClient : AFHTTPSessionManager

@property NSURLCache *xmanCache;

+(XmanClient*) sharedClient;

-(instancetype)initWithBaseURL:(NSURL *)url;

@end
