//
//  TBLoadMoreControl.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "TBLoadMoreControl.h"

#define kNormalWord @"Load More"
#define kLoadingWord @"Loading"
#define kNoMoreWord @""
#define kNoDataWord @"No results found"
#define kNoSearchDataWord @"We can't find a match for your search.Refine and try again."

@interface TBLoadMoreControl()
@property (nonatomic,strong)UILabel *lb;
@property (nonatomic,strong)UIActivityIndicatorView *actView;
@end

@implementation TBLoadMoreControl
{
    BOOL hasMore;
}
- (id)initMore{
    self = [super initWithFrame:CGRectMake(0, 0, UIScreenWidth, 44)];
    if (self) {
        _lb = [[UILabel alloc]initWithFrame:self.bounds];
        _lb.font = FONT(16);
        _lb.textColor = [UIColor blackColor];
        _lb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lb];
        
        _actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _actView.center = CGPointMake(UIScreenWidth - 50, self.height/2.);
        _actView.hidesWhenStopped = YES;
        [self addSubview:_actView];
        
        [self normalStyle];
        
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadMore)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired =1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)loadMore{
    if (hasMore) {
        if (self.LoadNextPageDataBlock) {
            self.LoadNextPageDataBlock();
        }
    }
}
- (void)changeStyle:(ControlStyle)style{
    switch (style) {
        case normal_style:
            [self normalStyle];
            break;
        case loading_style:
            [self loadingStyle];
            break;
        case nomore_style:
            [self noMoreStyle];
            break;
        case nodata_style:
            [self noDataStyle];
            break;
        case nosearch_style:
            [self noSearchDataStyle];
            break;
        default:
            break;
    }
}

- (void)normalStyle{
    hasMore = YES;
    _lb.text = kNormalWord;
    [_actView stopAnimating];
}

- (void)loadingStyle{
    _lb.text = kLoadingWord;
    [_actView startAnimating];
}

- (void)noMoreStyle{
    hasMore = NO;
    _lb.text = kNoMoreWord;
    [_actView stopAnimating];
    _lb.textColor = [UIColor darkGrayColor];
}

- (void)noDataStyle{
    hasMore = NO;
    _lb.text = kNoDataWord;
    [_actView stopAnimating];
    _lb.textColor = [UIColor darkGrayColor];

}

- (void)noSearchDataStyle{
    hasMore = NO;
    _lb.text = kNoSearchDataWord;
    _lb.numberOfLines = 0;
    [_lb sizeToFit];
    _lb.width = UIScreenWidth;
    [_actView stopAnimating];
    _lb.textColor = [UIColor darkGrayColor];
    
}

@end
