//
//  NewAdTitleDescCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAdTitleDescCell : UITableViewCell

@property (nonatomic,strong)void(^outputTitleBlock)(NSString *title);
@property (nonatomic,strong)void(^outputDescBlock)(NSString *desc);

@property (nonatomic,strong)void(^TextViewBeginEditBlock)(BOOL);
- (void)setAdTitle:(NSString *)title;
- (void)setAdDesc:(NSString *)desc;


@end
