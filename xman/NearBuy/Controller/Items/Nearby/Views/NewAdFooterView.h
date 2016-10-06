//
//  NewAdFooterView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewAdFooterViewDelegate <NSObject>

@required
- (void)buttonActionConfirm:(BOOL)confirm;

@end

@interface NewAdFooterView : UIView

@property (nonatomic,strong)id<NewAdFooterViewDelegate>delegate;
@end
