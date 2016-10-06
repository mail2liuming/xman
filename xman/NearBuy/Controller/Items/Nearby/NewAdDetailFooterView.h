//
//  NewAdDetailFooterView.h
//  NearBuy
//
//  Created by URoad_MP on 16/1/27.
//  Copyright © 2016年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtyAd.h"

@interface NewAdDetailFooterView : UIView

- (id)initWithEtyAd:(EtyAd*)ad withType:(FooterType)type;

@property (nonatomic,strong)EtyAd*attachAd;
@property (nonatomic,strong)void(^topButtonClickBlock)(void);
- (void)reloadFooterData;
@end
