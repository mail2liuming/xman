//
//  TBRefreshControl.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "TBRefreshControl.h"

#define kRefreshControlHeight 50
#define kNormalText @"Pull Down to Refresh"
#define kReleaseText @"Release to Refresh"
#define kLoadingText @"Refreshing"


@interface TBRefreshControl()<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *refreshImgView;
@property (nonatomic,strong)UILabel *refreshTitleLb;
@property (nonatomic,strong)UIScrollView *getScroll;
@end

@implementation TBRefreshControl
{
    BOOL refreshing;
}
- (id)initView{
    self = [super initWithFrame:CGRectMake(0, -44, UIScreenWidth, kRefreshControlHeight)];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"NaviRefresh"];
        _refreshImgView = [[UIImageView alloc]initWithImage:img];
        _refreshImgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        _refreshImgView.center = CGPointMake(UIScreenWidth/2., img.size.height /2);
        [self addSubview:_refreshImgView];
        
        _refreshTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 44 - 20, UIScreenWidth, 20)];
        _refreshTitleLb.text = kNormalText;
        _refreshTitleLb.textAlignment = NSTextAlignmentCenter;
        _refreshTitleLb.font = [UIFont systemFontOfSize:15];
        _refreshTitleLb.textColor = [UIColor lightGrayColor];
        [self addSubview:_refreshTitleLb];
        
    }
    return self;
}

- (void)addControlScrollView:(UIScrollView *)scView{
    self.getScroll = scView;
    UIView *contentV = [[UIView alloc]initWithFrame:CGRectMake(0,-scView.frame.size.height, scView.frame.size.width, scView.frame.size.height)];
    contentV.backgroundColor = [UIColor clearColor];
    [contentV addSubview:self];
    [scView addSubview:contentV];
    scView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat off_y = fabs(scrollView.contentOffset.y);//求绝对值
    NSLog(@"off_y %0.3f",off_y);
    if (refreshing) {
        return;
    }
    if (off_y >= 64+kRefreshControlHeight) {
        if (scrollView.isDragging) {
            _refreshTitleLb.text = kReleaseText;
        }else{
            _refreshTitleLb.text = kLoadingText;
        }
    }else if (off_y < 64+kRefreshControlHeight){
        _refreshTitleLb.text = kNormalText;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat off_y = fabs(scrollView.contentOffset.y);//求绝对值
    if (off_y>=64+kRefreshControlHeight) {

        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(64+kRefreshControlHeight, 0, 0, 0);
        } completion:^(BOOL finished) {
            [self startLoadingAnimation];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];

    }
}

- (void)startLoadingAnimation{
    if (refreshing) {
        return;
    }
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    
    [_refreshImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)endLoadingAnimation{
    [_refreshImgView.layer removeAllAnimations];
}

- (void)beginRefresh{
    [UIView animateWithDuration:0.2 animations:^{
        self.getScroll.contentInset = UIEdgeInsetsMake(64+kRefreshControlHeight, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self startLoadingAnimation];
    }];
}

- (void)endRefresh{
    [UIView animateWithDuration:0.2 animations:^{
        self.getScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        refreshing = NO;
        [self endLoadingAnimation];
    }];
}

@end
