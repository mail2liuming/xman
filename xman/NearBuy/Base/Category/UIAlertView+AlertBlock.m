//
//  UIAlertView+AlertBlock.m
//  AutoLayoutDemo
//
//  Created by 罗 建镇 on 14-7-23.
//  Copyright (c) 2014年 Luo Jianzhen. All rights reserved.
//

#import "UIAlertView+AlertBlock.h"
#import <objc/runtime.h>
@implementation UIAlertView (AlertBlock)

- (void)setCompletedBlock:(AlertCompletedBlock)completedBlock
{
    objc_setAssociatedObject(self, @selector(completedBlock), completedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (completedBlock == NULL) {
        self.delegate = nil;
    }else{
        self.delegate = self;
    }
}

- (AlertCompletedBlock)completedBlock
{
    return objc_getAssociatedObject(self, @selector(completedBlock));
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completedBlock) {
        self.completedBlock(self,buttonIndex);
    }
}

@end
