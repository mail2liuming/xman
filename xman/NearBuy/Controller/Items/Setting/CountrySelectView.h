//
//  CountrySelectView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountrySelectView : UIView

- (id)initWithDatas:(NSArray *)datas;
@property (nonatomic,strong)void(^dismissBlock)(void);
@property (nonatomic,strong)void(^confirmBlock)(NSString*name);
@property (strong, nonatomic) IBOutlet UIBarButtonItem *confirmBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *dismissBtn;
@end
