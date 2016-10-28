//
//  PhotoWrapper.m
//  xman
//
//  Created by Liu Ming on 12/09/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "PhotoWrapper.h"

@implementation PhotoWrapper

-(NSString*)showImageUrl{
    if(_localImageUrl !=nil){
        return _localImageUrl;
    }
    
    return _imageUrl;
}

+(NSArray*)toUrlArray:(NSArray *)array{
    if(array != nil){
        NSMutableArray* res = [[NSMutableArray alloc]init];
        for(PhotoWrapper* wrapper in array){
            [res addObject:wrapper.imageUrl];
        }
        return res;
    }
    
    return nil;
}

+(NSArray*)fromUrlArray:(NSArray *)array{
    if(array != nil){
        NSMutableArray* res = [[NSMutableArray alloc]init];
        int index = 0;
        for(NSString* url in array){
            PhotoWrapper* wrapper = [[PhotoWrapper alloc]init];
            wrapper.imageUrl = url;
            wrapper.index = index;
            [res addObject:wrapper];
            index++;
        }
        return res;
    }
    return nil;
}

@end
