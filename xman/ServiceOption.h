//
//  ServiceOption.h
//  xman
//
//  Created by Liu Ming on 3/10/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceOption : NSObject

extern NSString *const ServiceFieldLength;
extern NSString *const ServiceFieldService;
extern NSString *const ServiceFieldPrice;

@property(nonatomic,strong)NSString* length;
@property(nonatomic,strong)NSString* service;
@property(nonatomic,strong)NSString* price;

@end
