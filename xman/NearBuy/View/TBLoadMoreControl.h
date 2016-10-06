//
//  TBLoadMoreControl.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ControlStyle) {
    normal_style,
    loading_style,
    nomore_style,
    nodata_style,
    nosearch_style
};

@interface TBLoadMoreControl : UIView

- (id)initMore;

- (void)changeStyle:(ControlStyle)style;

@property (nonatomic,strong)void(^LoadNextPageDataBlock)(void);
@end
