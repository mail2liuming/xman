//
//  SubTabOfSell.m
//  NearBuy
//
//  Created by Liu Ming on 20/07/16.
//  Copyright © 2016 nearbuy. All rights reserved.
//

#import "SubTabOfSell.h"

@implementation SubTabOfSell

-(instancetype)init{
    self = [super init];
    
    self.datas = [NSMutableArray array];
    self.currentIndex = 1;
    
    return self;
}

@end
