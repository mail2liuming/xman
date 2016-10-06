//
//  ItemAdDetailController.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BaseController.h"
#import "EtyAd.h"
@interface ItemAdDetailController : BaseController

- (id)initWithAd:(EtyAd *)ad;

- (id)initWithAd:(EtyAd *)ad showWatch:(BOOL)show;

- (id)initWithAd:(EtyAd *)ad withEdit:(BOOL)edit;

- (id)initWithAd:(EtyAd *)ad withRelist:(BOOL)relist withStatus:(NSString*)status;

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)void(^ReloadListDataBlock)(void);

@property (nonatomic,assign)BOOL isWithdrawn;

@end
