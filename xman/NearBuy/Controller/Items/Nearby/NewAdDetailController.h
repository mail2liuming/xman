//
//  NewAdDetailController.h
//  NearBuy
//
//  Created by URoad_MP on 15/11/15.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import "BaseController.h"
#import "EtyAd.h"


@interface NewAdDetailController : BaseController

- (id)initWithAd:(EtyAd*)ad withFunction:(FUNCTIONCODE)func;

@property (nonatomic,assign)BOOL showWatch;
@property (nonatomic,strong)NSString *adStatus;

@property (nonatomic,strong)NSString *type;

@property (nonatomic,strong)void(^ReloadListDataBlock)(void);

@property (nonatomic,assign)BOOL isWithdrawn;

@end
