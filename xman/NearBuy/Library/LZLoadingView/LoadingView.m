//
//  LoadingView.m
//  Animation
//
//  Created by URoad_MP on 15/6/22.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)NSArray*imgs;
@property (nonatomic,strong)NSTimer *repeatTimer;
@property (nonatomic,strong)UIView *overlayView;
@end

@implementation LoadingView
{
    NSInteger currentPage;
}
+ (LoadingView *)sharedInstance{
    static LoadingView *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[LoadingView alloc]init];
    });
    return obj;
}

- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 192, 68)];
    if (self) {
        _overlayView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.alpha = 0.0;
        _overlayView.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopAnimation)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_overlayView addGestureRecognizer:tap];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.0;
        currentPage = 0;
        _imgs = @[[UIImage imageNamed:@"loading1"],[UIImage imageNamed:@"loading2"],[UIImage imageNamed:@"loading3"],[UIImage imageNamed:@"loading4"],[UIImage imageNamed:@"loading5"]];
        _imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imgView.image = _imgs[0];
        [self addSubview:_imgView];
    }
    return self;
}

- (void)showInView:(UIView *)view{
    self.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _overlayView.alpha = 0.3;
    [[UIApplication sharedApplication].keyWindow insertSubview:_overlayView belowSubview:self];
    [self startAnimation];
}

- (void)changeDot{
    if (currentPage==5) {
        currentPage = 0;
    }
    _imgView.image = _imgs[currentPage];
    currentPage +=1;
}

- (void)startAnimation{
    _repeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeDot) userInfo:nil repeats:YES];
    [self.repeatTimer fire];
}

- (void)stopAnimation{
    currentPage = 0;
    if (self.repeatTimer.isValid) {
        [self.repeatTimer invalidate];
    }
    _overlayView.alpha = 0.0;
    [_overlayView removeFromSuperview];
    [self removeFromSuperview];
}
@end
