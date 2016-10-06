//
//  LZPopAnimationView.m
//  Anmi
//
//  Created by 罗 建镇 on 15/3/20.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "LZPopAnimationView.h"
@interface LZPopAnimationView()
@property (nonatomic,strong)UIView *contentV;
@property (nonatomic,strong)UIImageView *blurImageView;
@end

@implementation LZPopAnimationView

+ (LZPopAnimationView *)addContentView:(UIView *)contentView{
    LZPopAnimationView *an = [[LZPopAnimationView alloc]initPopViewWithContentView:contentView];
    an.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height / 2.0);
    return an;
}



- (id)initPopViewWithContentView:(UIView *)contentv
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.contentV = contentv;
        self.contentV.center = self.center;
//        self.blurView = [[FXBlurView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        self.blurView.blurRadius = 0;
//        self.blurView.tintColor = [UIColor whiteColor];
//        self.blurView.dynamic = NO;
        
        self.blurImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.blurImageView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contentV];
//        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPop)];
//        [self addGestureRecognizer:dismissTap];
        
    }
    return self;
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
    [self.contentV.layer addAnimation:popAnimation forKey:nil];

    [UIView animateWithDuration:0.4 animations:^{
//        self.blurView.blurRadius = 0;
        self.blurImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.blurImageView removeFromSuperview];
    }];

}

- (void)showPop{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    UIImage *screenshot = [UIImage screenshot];
    NSData *imageData = UIImageJPEGRepresentation(screenshot, .0001);
    UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:0.4];
    self.blurImageView.image = blurredSnapshot;
    [KEY_WINDOW insertSubview:self.blurImageView belowSubview:self];
    self.blurImageView.alpha = 0;

    [UIView animateWithDuration:0.4 animations:^{
//        self.blurView.blurRadius = 30;
        self.blurImageView.alpha = 1;

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
    popAnimation.removedOnCompletion=YES;
    [self.contentV.layer addAnimation:popAnimation forKey:nil];

    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self.contentV removeFromSuperview];
    [self removeFromSuperview];
}

@end
