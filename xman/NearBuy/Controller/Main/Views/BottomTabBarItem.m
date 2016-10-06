//
//  BottomTabBarItem.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BottomTabBarItem.h"

@interface BottomTabBarItem()
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UIView *selectView;
@end

@implementation BottomTabBarItem

- (id)initWithFrame:(CGRect)frame byTitle:(NSString *)title bySelectImg:(UIImage *)sImg byUnSelectImg:(UIImage *)unImg{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, sImg.size.width, sImg.size.height)];
        _imgView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2 - 10);
        _imgView.image = unImg;
        _imgView.highlightedImage = sImg;
        [self addSubview:_imgView];
        
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
        _titleLb.text = title;
        if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5) {
            _titleLb.font = [UIFont systemFontOfSize:9];
        }else{
            _titleLb.font = [UIFont systemFontOfSize:11];

        }
        _titleLb.highlightedTextColor = [UIColor whiteColor];
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLb];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectThis)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)selectThis{
    if (self.selectThisItemBlock) {
        self.selectThisItemBlock(self.tag);
    }
}

- (void)selectSelf{
    _imgView.highlighted = YES;
    _titleLb.highlighted = YES;
    self.backgroundColor = UI_NAVIBAR_COLOR;
}

- (void)unselect{
    self.backgroundColor = [UIColor whiteColor];
    _imgView.highlighted = NO;
    _titleLb.highlighted = NO;
}

@end
