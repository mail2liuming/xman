//
//  FenLiuPicView.m
//  LNGaosutong
//
//  Created by URoad_MP on 15/5/5.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import "FenLiuPicView.h"
#import "LZImageZoomView.h"
@interface FenLiuPicView ()
@property (strong, nonatomic) LZImageZoomView *imgV;


@end

@implementation FenLiuPicView

- (id)initViewWithEty:(NSString *)urlString{
    self = LOAD_XIB_CLASS(FenLiuPicView);
    if (self) {
        _imgV = [[LZImageZoomView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight) byUrlString:urlString];
        _imgV.center = CGPointMake(_imgV.center.x, UIScreenHeight/2);
        
        [self addSubview:_imgV];
    }
    return self;
}

@end
