//
//  AdDetailFooterView.h
//  NearBuy
//
//  Created by URoad_MP on 15/11/20.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AdDetailFooterView : UIView

- (id)initViewWithWithType:(FooterType)type;

- (void)showHasFavi:(BOOL)favied;

@property (nonatomic,strong)void(^topButtonClickBlock)(void);

@property (nonatomic,strong)void(^secondButtonClickBlock)(void);
@end
