//
//  UIView+Extension.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(float)left{
    return self.frame.origin.x;
}
-(void)setLeft:(float)left{
    CGRect oriRect=self.frame;
    self.frame=CGRectMake(left, oriRect.origin.y, oriRect.size.width, oriRect.size.height);
}

-(float)top{
    return self.frame.origin.y;
}



-(void)setTop:(float)top{
    CGRect oriRect=self.frame;
    self.frame=CGRectMake(oriRect.origin.x, top, oriRect.size.width, oriRect.size.height);
}

-(float)width{
    return self.frame.size.width;
}

-(void)setWidth:(float)width{
    CGRect oriRect=self.frame;
    self.frame=CGRectMake(oriRect.origin.x, oriRect.origin.y, width, oriRect.size.height);
}

-(float)height{
    return self.frame.size.height;
}

-(void)setHeight:(float)height{
    CGRect oriRect=self.frame;
    self.frame=CGRectMake(oriRect.origin.x, oriRect.origin.y, oriRect.size.width,height);
}

-(CGSize)size{
    return self.frame.size;
}

-(void)setSize:(CGSize)size{
    CGPoint originPoint=self.frame.origin;
    self.frame=CGRectMake(originPoint.x, originPoint.y, size.width, size.height);
}

-(CGPoint)origin{
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin{
    CGSize oriSize=self.frame.size;
    self.frame=CGRectMake(origin.x, origin.y, oriSize.width, oriSize.height);
}

@end
