//
//  NewAdPriceCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAdPriceCell : UITableViewCell
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)void(^outputPriceBlock)(NSString *);
@property (nonatomic,strong)void(^TextFieldBeginEditBlock)(BOOL isShow);
@end
