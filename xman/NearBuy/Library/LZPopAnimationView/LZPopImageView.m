//
//  LZPopImageView.m
//  LZPopImageView
//
//  Created by 罗 建镇 on 15/3/26.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "LZPopImageView.h"

@interface LZPopImageView()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *sView;
@property (nonatomic,strong)UIImageView *imageV;

@property (nonatomic,strong)UIView *overlayView;
@end

@implementation LZPopImageView
{
    
}
+ (LZPopImageView *)showPopImageViewByImage:(UIImage *)image
{
    LZPopImageView *popView = [[LZPopImageView alloc]initPopImageViewWithImage:image];
    popView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height / 2.0);
    return popView;
}

- (id)initPopImageViewWithImage:(UIImage *)image{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
//        self.blurView = [[FXBlurView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        self.blurView.blurRadius = 0;
//        self.blurView.tintColor = [UIColor whiteColor];
//        self.blurView.dynamic = NO;
        
        self.overlayView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self.overlayView];

        
        self.sView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.sView.maximumZoomScale = 3.0;
        self.sView.minimumZoomScale = 1.0;
        self.sView.decelerationRate = 1.0;
        self.sView.showsHorizontalScrollIndicator = NO;
        self.sView.showsVerticalScrollIndicator = NO;
        self.sView.delegate=self;

        [self addSubview:self.sView];
        
        CGSize imgSize = image.size;
        CGFloat imgWidth = 0.0;
        CGFloat imgHeight = 0.0;
        //图片的长宽比
        CGFloat proportion = imgSize.width / imgSize.height;
        if (proportion>1) {
            imgWidth = [UIScreen mainScreen].bounds.size.width - 50;
            imgHeight = imgWidth / proportion;
        }else{
            imgHeight = [UIScreen mainScreen].bounds.size.height - 200;
            imgWidth = imgHeight * proportion;
        }
        
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgWidth, imgHeight)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        self.imageV.image = image;
        self.imageV.userInteractionEnabled=YES;
        self.imageV.center = self.sView.center;
        //图片默认作为2倍图处理
        [self.sView addSubview:self.imageV];

        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPop)];
        [self addGestureRecognizer:dismissTap];
        
        UITapGestureRecognizer *zoomInTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoFingleTap)];
        zoomInTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:zoomInTap];
        
        //// 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作 
        [dismissTap requireGestureRecognizerToFail:zoomInTap];
        
        [self showPop];
        
    }
    return self;
}


- (void)twoFingleTap{
    if (self.sView.zoomScale == 3) {
        [self.sView setZoomScale:1 animated:YES];
    }else{
        [self.sView setZoomScale:3 animated:YES];
    }
}
- (void)dismissPop{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            ];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    popAnimation.delegate = self;
    popAnimation.fillMode = kCAFillModeForwards;
    popAnimation.removedOnCompletion=NO;
    [self.imageV.layer addAnimation:popAnimation forKey:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.overlayView.alpha = 0;
    }];
    
}

- (void)showPop{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.overlayView.alpha = 0.5;
    }];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    popAnimation.removedOnCompletion=NO;
    [self.imageV.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self.imageV removeFromSuperview];
//    [self.blurView removeFromSuperview];
    [self.overlayView removeFromSuperview];
    [self removeFromSuperview];
}


#pragma mark -UIScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageV;
}

@end
