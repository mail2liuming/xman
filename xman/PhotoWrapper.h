//
//  PhotoWrapper.h
//  xman
//
//  Created by Liu Ming on 12/09/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoWrapper : NSObject

@property (nonatomic) int type;
@property (nonatomic) int index;
@property (nonatomic,strong) NSString* imageUrl;
@property (nonatomic,strong)NSString* localImageUrl;
@property (nonatomic,strong)NSString* showImageUrl;

+(NSArray*) toUrlArray:(NSArray*)array;
+(NSArray*) fromUrlArray:(NSArray*)array;

@end
