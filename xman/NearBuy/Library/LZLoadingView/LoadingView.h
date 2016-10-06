//
//  LoadingView.h
//  Animation
//
//  Created by URoad_MP on 15/6/22.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (LoadingView *)sharedInstance;

- (void)showInView:(UIView *)view;

- (void)startAnimation;

- (void)stopAnimation;

@end
