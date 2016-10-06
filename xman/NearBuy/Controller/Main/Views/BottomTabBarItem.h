//
//  BottomTabBarItem.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomTabBarItem : UIView

- (id)initWithFrame:(CGRect)frame byTitle:(NSString *)title bySelectImg:(UIImage *)sImg byUnSelectImg:(UIImage *)unImg;

@property (nonatomic,strong)void(^selectThisItemBlock)(NSInteger thisTag);

- (void)unselect;
- (void)selectSelf;
@end
