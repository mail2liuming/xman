//
//  AdCommentController.h
//  NearBuy
//
//  Created by URoad_MP on 15/9/8.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BaseController.h"
#import "EtyAd.h"
@interface AdCommentController : BaseController

- (id)initWithEty:(EtyAd *)ety;

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)void(^reloadTableData)(void);
@end
