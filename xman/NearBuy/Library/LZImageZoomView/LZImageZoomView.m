//
//  LZImageZoomView.m
//  imageDemo
//
//  Created by URoad_MP on 15/5/12.
//  Copyright (c) 2015年 future. All rights reserved.
//

#import "LZImageZoomView.h"

@interface LZImageZoomView()<UIScrollViewDelegate>
@property (nonatomic,retain)UIScrollView *sView;
@property (nonatomic,retain)UIImageView *imageV;
@property (nonatomic,retain)UIActivityIndicatorView *actView;
@end

@implementation LZImageZoomView

- (id)initWithFrame:(CGRect)frame byUrlString:(NSString *)urlString{
    self = [super initWithFrame:frame];
    if (self) {
        _sView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _sView.delegate = self;
        _sView.minimumZoomScale = 1.0;
        _sView.maximumZoomScale = 3.0;
        _sView.showsHorizontalScrollIndicator =NO;
        _sView.showsVerticalScrollIndicator = NO;
        _sView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        _sView.contentSize = CGSizeMake(999999, 9999999);
        [self addSubview:_sView];
        
        _imageV =[[UIImageView alloc]initWithFrame:self.bounds];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        [_sView addSubview:_imageV];
        
        _actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _actView.center = self.center;
        [self addSubview:_actView];
        
        [_actView startAnimating];
        
        [_imageV sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_actView stopAnimating];

        }];

        UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomAction)];
        twoTap.numberOfTapsRequired = 2;
        twoTap.numberOfTouchesRequired = 1;
        [_sView addGestureRecognizer:twoTap];
    }
    return self;
}

- (void)zoomAction{
    CGFloat currentScale = _sView.zoomScale;
    if(currentScale != _sView.maximumZoomScale){
        [_sView setZoomScale:_sView.maximumZoomScale animated:YES];
    }
    else {
        [_sView setZoomScale:_sView.minimumZoomScale animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageV;
}


@end
