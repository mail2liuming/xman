//
//  ItemNewAdController.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BaseController.h"
#import "EtyAd.h"
@interface ItemNewAdController : BaseController

- (id)initController;

- (id)initControllerWithEditMode:(EtyAd *)ad withPhotos:(NSArray*)photoss;

@property (nonatomic,strong)void(^reloadUIBlock)(void);
@property (nonatomic,strong)void(^reloadDataBlock)(EtyAd *);
@end
